USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudEmpleadosDetalleSu]    Script Date: 14/06/2019 11:33:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatSolicitudEmpleadosDetalleSu]
	 @SolicitudId INT
    ,@CatEmpleadoId INT
    ,@ConceptoMotivoId VARCHAR(50) = NULL
    ,@ResponsableId INT = NULL
    ,@PeriodoNomina VARCHAR(50)
	,@Active BIT
	,@TTConceptoMotivoId BIT
	,@TTManager_Ident BIT
	,@TTMonto BIT
	,@TTDetalle BIT
	,@TTPeriodoNomina BIT
	,@UserEmployeeId INT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	DECLARE @FechaActual DATETIME

	SET @FechaActual = GETDATE();
	SET @Estatus = ISNULL(@Estatus, 0)

	IF NOT EXISTS( SELECT 1 FROM [app620].CatSolicitudEmpleadosDetalle WHERE FolioSolicitud=@SolicitudId AND Empleado_Ident=@CatEmpleadoId)
	SET @Estatus = @Estatus -1

	IF @Estatus=0
	BEGIN
		UPDATE [app620].[CatSolicitudEmpleadosDetalle]
		SET
			 ConceptoMotivoId		= @ConceptoMotivoId
			,ResponsableId			= @ResponsableId
			,Active					= @Active
			,LastModifiedBy			= @UserEmployeeId
			,LastModifiedDate		= @FechaActual
			,DeactivatedBy			= IIF(@Active=0,NULL,@UserEmployeeId)
			,DeactivatedDate		= IIF(@Active=0,NULL,@FechaActual)
			,LastModifiedFromPCName	= HOST_NAME()
		WHERE FolioSolicitud=@SolicitudId AND Empleado_Ident=@CatEmpleadoId

		IF @TTConceptoMotivoId = 1
		BEGIN
			UPDATE [app620].[CatSolicitudEmpleadosDetalle]
			SET
				 ConceptoMotivoId		= @ConceptoMotivoId				
				,LastModifiedBy			= @UserEmployeeId
				,LastModifiedDate		= @FechaActual
				,DeactivatedBy			= IIF(@Active=0,NULL,@UserEmployeeId)
				,DeactivatedDate		= IIF(@Active=0,NULL,@FechaActual)
				,LastModifiedFromPCName	= HOST_NAME()
			WHERE FolioSolicitud=@SolicitudId AND Active =1

		END
		
		IF @TTManager_Ident = 1
		BEGIN
			UPDATE [app620].[CatSolicitudEmpleadosDetalle]
			SET
				ResponsableId			= @ResponsableId
				,LastModifiedBy			= @UserEmployeeId
				,LastModifiedDate		= @FechaActual
				,DeactivatedBy			= IIF(@Active=0,NULL,@UserEmployeeId)
				,DeactivatedDate		= IIF(@Active=0,NULL,@FechaActual)
				,LastModifiedFromPCName	= HOST_NAME()
			WHERE FolioSolicitud=@SolicitudId AND Active =1
		END

	  
	 -- IF @TTPeriodoNomina = 1
	 -- BEGIN
		--UPDATE [app620].[CatSolicitudEmpleadosDetalle]
		--SET
		--	,LastModifiedBy			= @UserEmployeeId
		--	,LastModifiedDate		= @FechaActual
		--	,DeactivatedBy			= IIF(@Active=0,NULL,@UserEmployeeId)
		--	,DeactivatedDate		= IIF(@Active=0,NULL,@FechaActual)
		--	,LastModifiedFromPCName	= HOST_NAME()
		--WHERE FolioSolicitud=@SolicitudId AND Empleado_Ident=@CatEmpleadoId
	 -- END

	END
END
