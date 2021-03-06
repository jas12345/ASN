USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatEmpleadosSolicitudesSi]    Script Date: 25/06/2019 01:23:05 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatEmpleadosSolicitudesSi]
	 @FolioSolicitud INT
    ,@Empleado_Ident INT
	,@conceptoid INT
	,@ParametroConceptoMonto DECIMAL(18,2) = NULL
	,@Motivo_Ident INT = NULL
    ,@Active BIT
	,@UserEmployeeId INT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	DECLARE @FechaActual DATETIME

	SET @FechaActual = GETDATE();
	SET @Estatus = ISNULL(@Estatus, 0)

	IF EXISTS( SELECT 1 FROM [app620].[CatEmpleadosSolicitudes] WHERE FolioSolicitud = @FolioSolicitud AND Empleado_Ident = @Empleado_Ident AND Active <> @Active)
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
			--,Manager_Ident
			,ParametroConceptoMonto
			--,Detalle
			,CreatedBy
			,LastModifiedBy
		)
		VALUES
		( 
			 @FolioSolicitud
			,@Empleado_Ident
			--,@Manager_Ident
			,@ParametroConceptoMonto
			--,@Detalle
			,@UserEmployeeId
			,@UserEmployeeId
		)
	END
END
