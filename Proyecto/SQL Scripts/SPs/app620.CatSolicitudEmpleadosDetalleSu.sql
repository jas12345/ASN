/****** Object:  StoredProcedure [app620].[CatSolicitudEmpleadosDetalleSu]    Script Date: 03/05/2019 06:12:13 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [app620].[CatSolicitudEmpleadosDetalleSu]
@SolicitudId INT
      ,@CatEmpleadoId INT
      ,@CatConceptoMotivoId VARCHAR(50) = NULL
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

	DECLARE 
		@AnioId INT = 0,
		@MesId INT = 0,
		@ConsecutivoId VARCHAR(5) = '',
		@PeriodicidadNominaId VARCHAR(5)='',
		@TipoPeriodo VARCHAR(5) =''

	SET @FechaActual = GETDATE();
	SET @Estatus = ISNULL(@Estatus, 0)

	--IF NOT EXISTS( SELECT 1 FROM [app620].CatSolicitudEmpleadosDetalle WHERE FolioSolicitud=@SolicitudId AND Empleado_Ident=@CatEmpleadoId)
	--SET @Estatus = @Estatus -1

	IF(@PeriodoNomina <> '')
		SELECT
			 @AnioId=AnioId
			,@MesId=MesId
			,@ConsecutivoId=ConsecutivoId
			,@PeriodicidadNominaId = PeriodicidadNominaId
			,@TipoPeriodo=TipoPeriodo 
		FROM app620.CatPeriodosNomina 
		WHERE NombrePeriodo = @PeriodoNomina

	IF @Estatus=0
	BEGIN
		UPDATE [app620].[CatSolicitudEmpleadosDetalle]
		SET
			CatConceptoMotivoId		= @CatConceptoMotivoId
			,ResponsableId			= @ResponsableId
			,PeriodoNomina			= @PeriodoNomina

			,PeriodoOriginalAnio_Id					= @AnioId	 
			,PeriodoOriginalMes_Id					= @MesId
			,PeriodoOriginalConsecutivoid			= @ConsecutivoId
			,PeriodoOriginalPeriodicidadNomina_Id	= @PeriodicidadNominaId
			,PeriodoOriginalTipoPeriodo_Id			= @TipoPeriodo

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
				CatConceptoMotivoId		= @CatConceptoMotivoId				

				,PeriodoOriginalAnio_Id					= @AnioId	 
				,PeriodoOriginalMes_Id					= @MesId
				,PeriodoOriginalConsecutivoid			= @ConsecutivoId
				,PeriodoOriginalPeriodicidadNomina_Id	= @PeriodicidadNominaId
				,PeriodoOriginalTipoPeriodo_Id			= @TipoPeriodo

				,LastModifiedBy			= @UserEmployeeId
				,LastModifiedDate		= @FechaActual
				,DeactivatedBy			= IIF(@Active=0,NULL,@UserEmployeeId)
				,DeactivatedDate		= IIF(@Active=0,NULL,@FechaActual)
				,LastModifiedFromPCName	= HOST_NAME()
			WHERE FolioSolicitud=@SolicitudId
		END
		
		IF @TTManager_Ident = 1
		BEGIN
			UPDATE [app620].[CatSolicitudEmpleadosDetalle]
			SET
				 ResponsableId			= @ResponsableId

				,PeriodoOriginalAnio_Id					= @AnioId	 
				,PeriodoOriginalMes_Id					= @MesId
				,PeriodoOriginalConsecutivoid			= @ConsecutivoId
				,PeriodoOriginalPeriodicidadNomina_Id	= @PeriodicidadNominaId
				,PeriodoOriginalTipoPeriodo_Id			= @TipoPeriodo

				,LastModifiedBy			= @UserEmployeeId
				,LastModifiedDate		= @FechaActual
				,DeactivatedBy			= IIF(@Active=0,NULL,@UserEmployeeId)
				,DeactivatedDate		= IIF(@Active=0,NULL,@FechaActual)
				,LastModifiedFromPCName	= HOST_NAME()
			WHERE FolioSolicitud=@SolicitudId
		END

	  
	  IF @TTPeriodoNomina = 1
	  BEGIN
		UPDATE [app620].[CatSolicitudEmpleadosDetalle]
		SET
			 PeriodoOriginalAnio_Id					= @AnioId	 
			,PeriodoOriginalMes_Id					= @MesId
			,PeriodoOriginalConsecutivoid			= @ConsecutivoId
			,PeriodoOriginalPeriodicidadNomina_Id	= @PeriodicidadNominaId
 
			,LastModifiedBy			= @UserEmployeeId
			,LastModifiedDate		= @FechaActual
			,DeactivatedBy			= IIF(@Active=0,NULL,@UserEmployeeId)
			,DeactivatedDate		= IIF(@Active=0,NULL,@FechaActual)
			,LastModifiedFromPCName	= HOST_NAME()
		WHERE FolioSolicitud=@SolicitudId AND Empleado_Ident=@CatEmpleadoId
	  END

	END
END
GO
