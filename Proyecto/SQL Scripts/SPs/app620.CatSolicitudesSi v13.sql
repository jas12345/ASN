USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudesSi]    Script Date: 02/07/2019 07:41:00 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatSolicitudesSi]
	 @FolioSolicitud INT = NULL
	,@EmployeeId INT 
	,@ConceptoId INT
	,@ConceptoMonto DECIMAL(18,2) = NULL
	,@MotivosSolicitudId INT = NULL
	,@ConceptoMotivoId INT = NULL
	,@ResponsableId INT = NULL
	,@PeriododOriginalId INT = NULL
	,@Autorizador1 INT = 0
	,@Autorizador2 INT = 0
	,@Autorizador3 INT = 0
	,@Autorizador4 INT = 0
	,@Autorizador5 INT = 0
	,@Autorizador6 INT = 0
	,@Autorizador7 INT = 0
	,@Autorizador8 INT = 0
	,@Autorizador9 INT = 0

	,@Active BIT = NULL
	,@UserEmployeeId INT = NULL

	,@FolioSolicitudOut INT = -1 OUTPUT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	
	DECLARE @idSolicitud INT =0
	DECLARE @FechaActual DATETIME
	--DECLARE @FolioSolicitudOut INT = 0

	SET @FechaActual = GETDATE();
	--SET @FolioSolicitudOut = -1;
	SET @Estatus = ISNULL(@Estatus, 0);
	SET @ConceptoMotivoId = ISNULL(@ConceptoMotivoId, 0)

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
		 0 = Proceso sin error
		-2 = Ya existe un registro con este Empleado y Concepto.
	*/

	SET @FolioSolicitudOut	= @FolioSolicitud


	IF EXISTS	(
					SELECT 1
					FROM app620.CatSolicitudes
					WHERE					
						FolioSolicitud	= @FolioSolicitud
				)
		BEGIN
			--SET @Estatus = '-1'
			SET @FolioSolicitudOut	= @FolioSolicitud
		END
	ELSE
		BEGIN
			DECLARE @inserted TABLE (
				[FolioSolicitud] [int]
			)

			INSERT INTO [app620].[CatSolicitudes]
			(
				 Fecha_Solicitud
				,Solicitante_Ident
				,EstatusSolicitudId
				,CreatedBy
				,CreatedDate
				,LastModifiedBy
				,LastModifiedDate
			)
			OUTPUT Inserted.FolioSolicitud INTO @inserted
			VALUES
			(
				 @FechaActual
				,@UserEmployeeId
				,'EB'
				,@UserEmployeeId
				,@FechaActual
				,@UserEmployeeId
				,@FechaActual
			)
				
			SELECT TOP 1 @FolioSolicitudOut = FolioSolicitud FROM @inserted;
			SET @Estatus= 0
		END

	 IF EXISTS(
				SELECT 1 FROM CatEmpleadosSolicitudes 
				WHERE
					FolioSolicitud	= @FolioSolicitud
				AND
					Empleado_Ident	= @EmployeeId
				AND
					ConceptoId		= @ConceptoId
				--AND
				--	Active			= 0
	)
		BEGIN
			UPDATE CatEmpleadosSolicitudes SET
				 ParametroConceptoMonto	= ISNULL(@ConceptoMonto, ParametroConceptoMonto)
				,MotivosSolicitudId		= ISNULL(@MotivosSolicitudId, MotivosSolicitudId)

				,[Active]				= ISNULL(@Active, Active)
				,LastModifiedBy			= @UserEmployeeId
				,LastModifiedDate		= @FechaActual

				,DeactivatedBy			= IIF(@Active=1,NULL,@UserEmployeeId)
				,DeactivatedDate		= IIF(@Active=1,NULL,@FechaActual)
				,LastModifiedFromPCName	= HOST_NAME()

			WHERE
				 FolioSolicitud			= @FolioSolicitud
			AND
				Empleado_Ident			= @EmployeeId
			AND
				ConceptoId				= @ConceptoId
		END

	ELSE IF NOT EXISTS(
				SELECT 1 FROM CatEmpleadosSolicitudes 
				WHERE
					FolioSolicitud	= @FolioSolicitud
				AND
					Empleado_Ident	= @EmployeeId
				AND
					ConceptoId		= @ConceptoId
				--AND
				--	Active			= 1
	)
		BEGIN
			INSERT INTO CatEmpleadosSolicitudes
			(
				 FolioSolicitud
				,Empleado_Ident
				,ConceptoId
				,ParametroConceptoMonto
				,MotivosSolicitudId
				,Active
				,CreatedBy
				,CreatedDate
				,LastModifiedBy
				,LastModifiedDate
			)
			VALUES
			(
				 @FolioSolicitudOut
				,@EmployeeId 
				,@ConceptoId
				,@ConceptoMonto
				,@MotivosSolicitudId
				,@Active
				,@UserEmployeeId
				,@FechaActual
				,@UserEmployeeId
				,@FechaActual
			)
		END
	--ELSE
	--	BEGIN
	--		SET @Estatus = '-2'
	--	END

	IF (@Estatus = 0)
		BEGIN
			IF (@ConceptoMotivoId <> 0)
				BEGIN

					IF NOT EXISTS(
						SELECT 1 
						FROM CatSolicitudEmpleadosDetalle 
						WHERE
							FolioSolicitud		= @FolioSolicitud
						AND
							Empleado_Ident		= @EmployeeId
						AND
							ConceptoId			= @ConceptoId
						AND
							ConceptoMotivoId	= @ConceptoMotivoId
					)
						BEGIN
							INSERT INTO CatSolicitudEmpleadosDetalle
							(
								 FolioSolicitud
								,Empleado_Ident
								,ConceptoId
								,ConceptoMotivoId
								,ResponsableId
								,PeriodoOriginalId
								,CreatedBy
								,CreatedDate
								,LastModifiedBy
								,LastModifiedDate

							)
							VALUES
							(
								 @FolioSolicitudOut
								,@EmployeeId 
								,@ConceptoId
								,@ConceptoMotivoId
								,@ResponsableId
								,@PeriododOriginalId
								,@UserEmployeeId
								,@FechaActual
								,@UserEmployeeId
								,@FechaActual
							)
						END
					ELSE IF EXISTS(
						SELECT 1 
						FROM CatSolicitudEmpleadosDetalle 
						WHERE
							FolioSolicitud		= @FolioSolicitud
						AND
							Empleado_Ident		= @EmployeeId
						AND
							ConceptoId			= @ConceptoId
						AND
							ConceptoMotivoId	= @ConceptoMotivoId
					)					
						BEGIN
							UPDATE CatSolicitudEmpleadosDetalle SET
								 ResponsableId			= ISNULL(@ResponsableId, ResponsableId)
								,PeriodoOriginalId		= ISNULL(@PeriododOriginalId, PeriodoOriginalId)
								,[Active]				= ISNULL(@Active, Active)
								,LastModifiedBy			= @UserEmployeeId
								,LastModifiedDate		= @FechaActual

								,DeactivatedBy			= IIF(@Active=1,NULL,@UserEmployeeId)
								,DeactivatedDate		= IIF(@Active=1,NULL,@FechaActual)
								,LastModifiedFromPCName	= HOST_NAME()

							WHERE
								 FolioSolicitud			= @FolioSolicitud
							AND
								Empleado_Ident			= @EmployeeId
							AND
								ConceptoId				= @ConceptoId
							AND
								ConceptoMotivoId		= @ConceptoMotivoId
						END
					
				END
		END
		
END
