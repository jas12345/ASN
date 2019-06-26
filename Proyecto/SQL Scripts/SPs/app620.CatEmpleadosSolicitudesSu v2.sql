USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatEmpleadosSolicitudesSu]    Script Date: 25/06/2019 11:33:56 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatEmpleadosSolicitudesSu]
	   @FolioSolicitud INT
      ,@Empleado_Ident INT
      ,@ConceptoId INT
	  ,@ParametroConceptoMonto DECIMAL(18,2) = NULL
      ,@MotivosSolicitudId INT = NULL
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
		SET  ParametroConceptoMonto = ISNULL(@ParametroConceptoMonto, ParametroConceptoMonto)
			,MotivosSolicitudId		= ISNULL(@MotivosSolicitudId, MotivosSolicitudId)
			,Active					= @Active
			,LastModifiedBy			= @UserEmployeeId
			,LastModifiedDate		= @FechaActual
			,DeactivatedBy			= IIF(@Active=0,NULL,@UserEmployeeId)
			,DeactivatedDate		= IIF(@Active=0,NULL,@FechaActual)
			,LastModifiedFromPCName	= HOST_NAME()
		WHERE 
			FolioSolicitud	= @FolioSolicitud 
		AND 
			Empleado_Ident	= @Empleado_Ident
		AND
			ConceptoId		= @ConceptoId		
	END
END


