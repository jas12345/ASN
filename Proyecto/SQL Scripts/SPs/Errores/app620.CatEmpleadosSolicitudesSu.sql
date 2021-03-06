USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatEmpleadosSolicitudesSu]    Script Date: 20/06/2019 12:06:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatEmpleadosSolicitudesSu]
	   @FolioSolicitud INT
      ,@Empleado_Ident INT
	  ,@ParametroConceptoMonto DECIMAL(18,2)
	  ,@Detalle VARCHAR(250)
	  ,@Active BIT	
	  ,@UserEmployeeId INT
	  ,@Estatus INT = 0 OUTPUT
AS
BEGIN
	DECLARE @FechaActual DATETIME

	SET @FechaActual = GETDATE();
	SET @Estatus = ISNULL(@Estatus, 0)

	IF NOT EXISTS( SELECT 1 FROM [app620].[CatEmpleadosSolicitudes] WHERE FolioSolicitud=@FolioSolicitud AND Empleado_Ident=@Empleado_Ident)
	SET @Estatus = @Estatus -1

	IF @Estatus=0
	BEGIN
		UPDATE[app620].[CatEmpleadosSolicitudes]
		SET Active					= @Active
			,ParametroConceptoMonto = @ParametroConceptoMonto
			,Detalle				= @Detalle
			,LastModifiedBy			= @UserEmployeeId
			,LastModifiedDate		= @FechaActual
			,DeactivatedBy			= IIF(@Active=0,NULL,@UserEmployeeId)
			,DeactivatedDate		= IIF(@Active=0,NULL,@FechaActual)
			,LastModifiedFromPCName	= HOST_NAME()
		WHERE FolioSolicitud=@FolioSolicitud AND Empleado_Ident=@Empleado_Ident
		
	END
END
