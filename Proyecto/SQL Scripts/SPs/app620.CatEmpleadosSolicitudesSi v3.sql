USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatEmpleadosSolicitudesSi]    Script Date: 12/06/2019 04:59:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatEmpleadosSolicitudesSi]
	 @FolioSolicitud INT
    ,@Empleado_Ident INT
    ,@Manager_Ident INT
	,@ParametroConceptoMonto DECIMAL(18,2)
	,@Detalle VARCHAR(250)
	,@UserEmployeeId INT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	DECLARE @FechaActual DATETIME

	SET @FechaActual = GETDATE();
	SET @Estatus = ISNULL(@Estatus, 0)

	IF EXISTS( SELECT 1 FROM [app620].[CatEmpleadosSolicitudes] WHERE FolioSolicitud = @FolioSolicitud AND Empleado_Ident = @Empleado_Ident)
		SET @Estatus = @Estatus -1

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
		 0 = Proceso sin error
		-1 = Ya existe un registro con los mismos parametros.
	*/

	IF @Estatus=0
	BEGIN
		INSERT INTO [app620].[CatEmpleadosSolicitudes]
		(
			 FolioSolicitud
			,Empleado_Ident
			,Manager_Ident
			,ParametroConceptoMonto
			,Detalle
			,Active
			,CreatedBy
			,LastModifiedBy
		)
		VALUES
		( 
			 @FolioSolicitud
			,@Empleado_Ident
			,@Manager_Ident
			,@ParametroConceptoMonto
			,@Detalle
			,1
			,@UserEmployeeId
			,@UserEmployeeId
		)
	END
END
