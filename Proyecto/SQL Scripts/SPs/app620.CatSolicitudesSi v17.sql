USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudesSi]    Script Date: 03/07/2019 09:52:03 a. m. ******/
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
			--------SELECT 'Existe Concepto 17' 'Concepto 17'

			--------SELECT @Active Active

			--------SELECT
			--------	 @FolioSolicitud	FolioSolicitud
			--------	,@EmployeeId		Empleado_Ident			
			--------	,@ConceptoId		ConceptoId				


			UPDATE CatEmpleadosSolicitudes SET
				 ParametroConceptoMonto	= ISNULL(@ConceptoMonto, ParametroConceptoMonto)
				,MotivosSolicitudId		= ISNULL(@MotivosSolicitudId, MotivosSolicitudId)

				,Active					= ISNULL(@Active, Active)
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

	ELSE 
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

	--------SELECT
	--------	 @FolioSolicitudOut	FolioSolicitud
	--------	,@EmployeeId		Empleado_Ident
	--------	,@ConceptoId		ConceptoId
	--------	,1					NivelAutorizacion

	IF (@Estatus = 0)
		BEGIN

			IF NOT EXISTS(
				SELECT 1 
				FROM CatSolicitudEmpleadosDetalle 
				WHERE
					FolioSolicitud		= @FolioSolicitudOut
				AND
					Empleado_Ident		= @EmployeeId
				AND
					ConceptoId			= @ConceptoId
			--  Comentario para evitar múltiples registros de Detalles de Solicitud de Empleado
			--	AND
			--		ConceptoMotivoId	= @ConceptoMotivoId
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
			ELSE 					
				BEGIN

					--------SELECT 'UPDATE CatSolicitudEmpleadosDetalle' 'UPDATE CatSolicitudEmpleadosDetalle'

					--------SELECT @Active Active

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
							FolioSolicitud			= @FolioSolicitudOut
					AND
						Empleado_Ident			= @EmployeeId
					AND
						ConceptoId				= @ConceptoId
				--  Comentario para evitar múltiples registros de Detalles de Solicitud de Empleado
				--	AND
				--		ConceptoMotivoId		= @ConceptoMotivoId
				END

			--------IF (@ConceptoMotivoId = 0)
			--------	BEGIN
			--------		UPDATE CatSolicitudEmpleadosDetalle SET
			--------			 ResponsableId			= ISNULL(@ResponsableId, ResponsableId)
			--------			,PeriodoOriginalId		= ISNULL(@PeriododOriginalId, PeriodoOriginalId)
			--------			,[Active]				= 0
			--------			,LastModifiedBy			= @UserEmployeeId
			--------			,LastModifiedDate		= @FechaActual

			--------			,DeactivatedBy			= IIF(@Active=1,NULL,@UserEmployeeId)
			--------			,DeactivatedDate		= IIF(@Active=1,NULL,@FechaActual)
			--------			,LastModifiedFromPCName	= HOST_NAME()

			--------		WHERE
			--------				FolioSolicitud			= @FolioSolicitudOut
			--------		AND
			--------			Empleado_Ident			= @EmployeeId
			--------		AND
			--------			ConceptoId				= @ConceptoId
			--------	--  Comentario para evitar múltiples registros de Detalles de Solicitud de Empleado
			--------	--	AND
			--------	--		ConceptoMotivoId		= @ConceptoMotivoId
			--------	END
		END
		
	------SELECT 1 ExisteAutorizadorNivel1
	------FROM [app620].CatSolicitudEmpleadosAutorizantes
	------WHERE
	------	FolioSolicitud		= @FolioSolicitudOut
	------AND
	------	Empleado_Ident		= @EmployeeId
	------AND
	------	ConceptoId			= @ConceptoId
	------AND
	------	NivelAutorizacion	= 1
						
	--END

	IF NOT EXISTS(
		SELECT 1 
		FROM [app620].CatSolicitudEmpleadosAutorizantes
		WHERE
			FolioSolicitud		= @FolioSolicitudOut
		AND
			Empleado_Ident		= @EmployeeId
		AND
			ConceptoId			= @ConceptoId
		AND
			NivelAutorizacion	= 1
	)
		BEGIN
			INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
				(FolioSolicitud
				,Empleado_Ident
				,ConceptoId
				,NivelAutorizacion
				,Autorizador_Ident
				,CreatedBy
				,CreatedDate
				,LastModifiedBy
				,LastModifiedDate)
			VALUES
				(@FolioSolicitudOut
				,@EmployeeId
				,@ConceptoId
				,1
				,@Autorizador1
				,@UserEmployeeId
				,@FechaActual
				,@UserEmployeeId
				,@FechaActual)
		END
	ELSE
		BEGIN
			UPDATE [app620].[CatSolicitudEmpleadosAutorizantes]
				SET  Autorizador_Ident			= @Autorizador1

					,Active						= ISNULL(@Active, Active)
					,LastModifiedBy				= @UserEmployeeId
					,LastModifiedDate			= @FechaActual

					,DeactivatedBy				= IIF(@Active=1,NULL,@UserEmployeeId)
					,DeactivatedDate			= IIF(@Active=1,NULL,@FechaActual)
					,LastModifiedFromPCName		= HOST_NAME()
				WHERE FolioSolicitud				= @FolioSolicitudOut
				AND Empleado_Ident				= @EmployeeId
				AND ConceptoId					= @ConceptoId
				AND NivelAutorizacion			= 1
		END

	IF NOT EXISTS(
		SELECT 1 
		FROM CatSolicitudEmpleadosAutorizantes
		WHERE
			FolioSolicitud		= @FolioSolicitudOut
		AND
			Empleado_Ident		= @EmployeeId
		AND
			ConceptoId			= @ConceptoId
		AND
			NivelAutorizacion	= 2
	)
		BEGIN
			INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
				(FolioSolicitud
				,Empleado_Ident
				,ConceptoId
				,NivelAutorizacion
				,Autorizador_Ident
				,CreatedBy
				,CreatedDate
				,LastModifiedBy
				,LastModifiedDate)
			VALUES
				(@FolioSolicitudOut
				,@EmployeeId
				,@ConceptoId
				,2
				,@Autorizador2
				,@UserEmployeeId
				,@FechaActual
				,@UserEmployeeId
				,@FechaActual)

		END
	ELSE 
		BEGIN
			UPDATE [app620].[CatSolicitudEmpleadosAutorizantes]
				SET  Autorizador_Ident			= @Autorizador2

					,Active						= ISNULL(@Active, Active)
					,LastModifiedBy				= @UserEmployeeId
					,LastModifiedDate			= @FechaActual

					,DeactivatedBy				= IIF(@Active=1,NULL,@UserEmployeeId)
					,DeactivatedDate			= IIF(@Active=1,NULL,@FechaActual)
					,LastModifiedFromPCName		= HOST_NAME()
					WHERE FolioSolicitud				= @FolioSolicitudOut
					AND Empleado_Ident				= @EmployeeId
					AND ConceptoId					= @ConceptoId
					AND NivelAutorizacion			= 2
		END

	IF NOT EXISTS(
		SELECT 1 
		FROM CatSolicitudEmpleadosAutorizantes
		WHERE
			FolioSolicitud		= @FolioSolicitudOut
		AND
			Empleado_Ident		= @EmployeeId
		AND
			ConceptoId			= @ConceptoId
		AND
			NivelAutorizacion	= 3
	)
		BEGIN
			INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
				(FolioSolicitud
				,Empleado_Ident
				,ConceptoId
				,NivelAutorizacion
				,Autorizador_Ident
				,CreatedBy
				,CreatedDate
				,LastModifiedBy
				,LastModifiedDate)
			VALUES
				(@FolioSolicitudOut
				,@EmployeeId
				,@ConceptoId
				,3
				,@Autorizador3
				,@UserEmployeeId
				,@FechaActual
				,@UserEmployeeId
				,@FechaActual)

		END
	ELSE 
		BEGIN
			UPDATE [app620].[CatSolicitudEmpleadosAutorizantes]
				SET  Autorizador_Ident			= @Autorizador3

					,Active						= ISNULL(@Active, Active)
					,LastModifiedBy				= @UserEmployeeId
					,LastModifiedDate			= @FechaActual

					,DeactivatedBy				= IIF(@Active=1,NULL,@UserEmployeeId)
					,DeactivatedDate			= IIF(@Active=1,NULL,@FechaActual)
					,LastModifiedFromPCName		= HOST_NAME()
			WHERE FolioSolicitud				= @FolioSolicitudOut
			AND Empleado_Ident				= @EmployeeId
			AND ConceptoId					= @ConceptoId
			AND NivelAutorizacion			= 3
		END

	IF NOT EXISTS(
		SELECT 1 
		FROM CatSolicitudEmpleadosAutorizantes
		WHERE
			FolioSolicitud		= @FolioSolicitudOut
		AND
			Empleado_Ident		= @EmployeeId
		AND
			ConceptoId			= @ConceptoId
		AND
			NivelAutorizacion	= 4
	)
		BEGIN
			INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
				(FolioSolicitud
				,Empleado_Ident
				,ConceptoId
				,NivelAutorizacion
				,Autorizador_Ident
				,CreatedBy
				,CreatedDate
				,LastModifiedBy
				,LastModifiedDate)
			VALUES
				(@FolioSolicitudOut
				,@EmployeeId
				,@ConceptoId
				,4
				,@Autorizador4
				,@UserEmployeeId
				,@FechaActual
				,@UserEmployeeId
				,@FechaActual)

		END
	ELSE 
		BEGIN
			UPDATE [app620].[CatSolicitudEmpleadosAutorizantes]
				SET  Autorizador_Ident			= @Autorizador4

					,Active						= ISNULL(@Active, Active)
					,LastModifiedBy				= @UserEmployeeId
					,LastModifiedDate			= @FechaActual

					,DeactivatedBy				= IIF(@Active=1,NULL,@UserEmployeeId)
					,DeactivatedDate			= IIF(@Active=1,NULL,@FechaActual)
					,LastModifiedFromPCName		= HOST_NAME()
			WHERE FolioSolicitud				= @FolioSolicitudOut
			AND Empleado_Ident				= @EmployeeId
			AND ConceptoId					= @ConceptoId
			AND NivelAutorizacion			= 4
		END

	IF NOT EXISTS(
		SELECT 1 
		FROM CatSolicitudEmpleadosAutorizantes
		WHERE
			FolioSolicitud		= @FolioSolicitudOut
		AND
			Empleado_Ident		= @EmployeeId
		AND
			ConceptoId			= @ConceptoId
		AND
			NivelAutorizacion	= 5
	)
		BEGIN
			INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
				(FolioSolicitud
				,Empleado_Ident
				,ConceptoId
				,NivelAutorizacion
				,Autorizador_Ident
				,CreatedBy
				,CreatedDate
				,LastModifiedBy
				,LastModifiedDate)
			VALUES
				(@FolioSolicitudOut
				,@EmployeeId
				,@ConceptoId
				,5
				,@Autorizador5
				,@UserEmployeeId
				,@FechaActual
				,@UserEmployeeId
				,@FechaActual)

		END
	ELSE 
		BEGIN
			UPDATE [app620].[CatSolicitudEmpleadosAutorizantes]
				SET  Autorizador_Ident			= @Autorizador5

					,Active						= ISNULL(@Active, Active)
					,LastModifiedBy				= @UserEmployeeId
					,LastModifiedDate			= @FechaActual

					,DeactivatedBy				= IIF(@Active=1,NULL,@UserEmployeeId)
					,DeactivatedDate			= IIF(@Active=1,NULL,@FechaActual)
					,LastModifiedFromPCName		= HOST_NAME()
				WHERE FolioSolicitud			= @FolioSolicitudOut
				AND Empleado_Ident				= @EmployeeId
				AND ConceptoId					= @ConceptoId
				AND NivelAutorizacion			= 5
		END

	IF NOT EXISTS(
		SELECT 1 
		FROM CatSolicitudEmpleadosAutorizantes
		WHERE
			FolioSolicitud		= @FolioSolicitudOut
		AND
			Empleado_Ident		= @EmployeeId
		AND
			ConceptoId			= @ConceptoId
		AND
			NivelAutorizacion	= 6
	)
		BEGIN
			INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
				(FolioSolicitud
				,Empleado_Ident
				,ConceptoId
				,NivelAutorizacion
				,Autorizador_Ident
				,CreatedBy
				,CreatedDate
				,LastModifiedBy
				,LastModifiedDate)
			VALUES
				(@FolioSolicitudOut
				,@EmployeeId
				,@ConceptoId
				,6
				,@Autorizador6
				,@UserEmployeeId
				,@FechaActual
				,@UserEmployeeId
				,@FechaActual)

		END
	ELSE 
		BEGIN
			UPDATE [app620].[CatSolicitudEmpleadosAutorizantes]
				SET  Autorizador_Ident			= @Autorizador6

					,Active						= ISNULL(@Active, Active)
					,LastModifiedBy				= @UserEmployeeId
					,LastModifiedDate			= @FechaActual

					,DeactivatedBy				= IIF(@Active=1,NULL,@UserEmployeeId)
					,DeactivatedDate			= IIF(@Active=1,NULL,@FechaActual)
					,LastModifiedFromPCName		= HOST_NAME()
				WHERE FolioSolicitud			= @FolioSolicitudOut
				AND Empleado_Ident				= @EmployeeId
				AND ConceptoId					= @ConceptoId
				AND NivelAutorizacion			= 6
		END

	IF NOT EXISTS(
		SELECT 1 
		FROM CatSolicitudEmpleadosAutorizantes
		WHERE
			FolioSolicitud		= @FolioSolicitudOut
		AND
			Empleado_Ident		= @EmployeeId
		AND
			ConceptoId			= @ConceptoId
		AND
			NivelAutorizacion	= 7
	)
		BEGIN
			INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
				(FolioSolicitud
				,Empleado_Ident
				,ConceptoId
				,NivelAutorizacion
				,Autorizador_Ident
				,CreatedBy
				,CreatedDate
				,LastModifiedBy
				,LastModifiedDate)
			VALUES
				(@FolioSolicitudOut
				,@EmployeeId
				,@ConceptoId
				,7
				,@Autorizador7
				,@UserEmployeeId
				,@FechaActual
				,@UserEmployeeId
				,@FechaActual)

		END
	ELSE 
		BEGIN
			UPDATE [app620].[CatSolicitudEmpleadosAutorizantes]
				SET  Autorizador_Ident			= @Autorizador7

					,Active						= ISNULL(@Active, Active)
					,LastModifiedBy				= @UserEmployeeId
					,LastModifiedDate			= @FechaActual

					,DeactivatedBy				= IIF(@Active=1,NULL,@UserEmployeeId)
					,DeactivatedDate			= IIF(@Active=1,NULL,@FechaActual)
					,LastModifiedFromPCName		= HOST_NAME()
				WHERE FolioSolicitud			= @FolioSolicitudOut
				AND Empleado_Ident				= @EmployeeId
				AND ConceptoId					= @ConceptoId
				AND NivelAutorizacion			= 7
		END

	IF NOT EXISTS(
		SELECT 1 
		FROM CatSolicitudEmpleadosAutorizantes
		WHERE
			FolioSolicitud		= @FolioSolicitudOut
		AND
			Empleado_Ident		= @EmployeeId
		AND
			ConceptoId			= @ConceptoId
		AND
			NivelAutorizacion	= 8
	)
		BEGIN
			INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
				(FolioSolicitud
				,Empleado_Ident
				,ConceptoId
				,NivelAutorizacion
				,Autorizador_Ident
				,CreatedBy
				,CreatedDate
				,LastModifiedBy
				,LastModifiedDate)
			VALUES
				(@FolioSolicitudOut
				,@EmployeeId
				,@ConceptoId
				,8
				,@Autorizador8
				,@UserEmployeeId
				,@FechaActual
				,@UserEmployeeId
				,@FechaActual)

		END
	ELSE 
		BEGIN
			UPDATE [app620].[CatSolicitudEmpleadosAutorizantes]
				SET  Autorizador_Ident			= @Autorizador8

					,Active						= ISNULL(@Active, Active)
					,LastModifiedBy				= @UserEmployeeId
					,LastModifiedDate			= @FechaActual

					,DeactivatedBy				= IIF(@Active=1,NULL,@UserEmployeeId)
					,DeactivatedDate			= IIF(@Active=1,NULL,@FechaActual)
					,LastModifiedFromPCName		= HOST_NAME()
				WHERE FolioSolicitud			= @FolioSolicitudOut
				AND Empleado_Ident				= @EmployeeId
				AND ConceptoId					= @ConceptoId
				AND NivelAutorizacion			= 8
		END

	IF NOT EXISTS(
		SELECT 1 
		FROM CatSolicitudEmpleadosAutorizantes
		WHERE
			FolioSolicitud		= @FolioSolicitudOut
		AND
			Empleado_Ident		= @EmployeeId
		AND
			ConceptoId			= @ConceptoId
		AND
			NivelAutorizacion	= 9
	)
		BEGIN
			INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
				(FolioSolicitud
				,Empleado_Ident
				,ConceptoId
				,NivelAutorizacion
				,Autorizador_Ident
				,CreatedBy
				,CreatedDate
				,LastModifiedBy
				,LastModifiedDate)
			VALUES
				(@FolioSolicitudOut
				,@EmployeeId
				,@ConceptoId
				,9
				,@Autorizador9
				,@UserEmployeeId
				,@FechaActual
				,@UserEmployeeId
				,@FechaActual)

		END
	ELSE 
		BEGIN
			UPDATE [app620].[CatSolicitudEmpleadosAutorizantes]
				SET  Autorizador_Ident			= @Autorizador9

					,Active						= ISNULL(@Active, Active)
					,LastModifiedBy				= @UserEmployeeId
					,LastModifiedDate			= @FechaActual

					,DeactivatedBy				= IIF(@Active=1,NULL,@UserEmployeeId)
					,DeactivatedDate			= IIF(@Active=1,NULL,@FechaActual)
					,LastModifiedFromPCName		= HOST_NAME()
				WHERE FolioSolicitud			= @FolioSolicitudOut
				AND Empleado_Ident				= @EmployeeId
				AND ConceptoId					= @ConceptoId
				AND NivelAutorizacion			= 9
		END
END
