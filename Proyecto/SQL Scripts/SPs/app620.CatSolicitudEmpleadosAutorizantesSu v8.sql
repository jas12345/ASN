USE [ASN2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatSolicitudEmpleadosAutorizantesSu]
	 @FolioSolicitud INT = 0
	,@Empleado_Ident INT = 0
	,@Concepto_Id INT = 0
	,@NivelAutorizacion INT =0
	,@Autorizador_Ident INT = 0
	,@Accion INT = 0
	,@UserEmployeeId INT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN

	DECLARE
		 @CantidadTotal		INT = 0
		,@CantidadTotalAC	INT = 0
		,@CantidadTotalR	INT = 0

	IF NOT EXISTS(
		SELECT 1 
		FROM app620.CatSolicitudEmpleadosAutorizantes 
		WHERE FolioSolicitud	= @FolioSolicitud 
		AND Empleado_Ident		= @Empleado_Ident 
		AND Autorizador_Ident	= @Autorizador_Ident
		AND NivelAutorizacion	= @NivelAutorizacion
	)
	SET @Estatus =-1

	IF(@Estatus =0)
		BEGIN
			UPDATE app620.CatSolicitudEmpleadosAutorizantes
			SET 
				 Pendiente	= (CASE WHEN @Accion = 1 THEN 1 ELSE 0 END)--Pendiente
				,Autorizado	= (CASE WHEN @Accion = 2 THEN 1 ELSE 0 END)--Autorizado
				,Rechazado	= (CASE WHEN @Accion = 3 THEN 1 ELSE 0 END)--Rechazado
				,Cancelado	= (CASE WHEN @Accion = 4 THEN 1 ELSE 0 END)--Cancelado
			WHERE
				FolioSolicitud		= @FolioSolicitud
			AND
				Empleado_Ident		= @Empleado_Ident
			AND
				ConceptoId			= @Concepto_Id
			AND
				NivelAutorizacion	= @NivelAutorizacion
			AND
				Autorizador_Ident	= @Autorizador_Ident
		END

		IF (@Accion <> 3)
			-- Se actualiza la nueva solicitud Pendiente
			BEGIN

				IF (@Accion = 2)
					BEGIN

						--Se calcula la cantidad de conceptos rechazados en la solicitud
						SELECT	@CantidadTotalR		= COUNT(1) 
						FROM	app620.CatEmpleadosSolicitudes 
						WHERE	FolioSolicitud		= @FolioSolicitud
						--AND		Empleado_Ident		= @Empleado_Ident
						AND		EstatusSolicitudId	= 'R'

						-- En esta sección se revisa si la solicitud Completa pasa a Pendiente de Autorizar (No existen Conceptos en estatus Rechazado)
						IF (@CantidadTotalR = 0) 
						BEGIN
							UPDATE app620.CatSolicitudes 
							SET EstatusSolicitudId = 'PA'
							WHERE FolioSolicitud = @FolioSolicitud
						END
					END

				-- En esta sección se revisa si el concepto de la solicitud pasa a Autorizado
				SELECT	@CantidadTotalAC =	COUNT(1) 
				FROM	app620.CatSolicitudEmpleadosAutorizantes 
				WHERE	FolioSolicitud		= @FolioSolicitud
				AND		Empleado_Ident		= @Empleado_Ident
				AND		ConceptoId			= @Concepto_Id
				AND		(Autorizado = 1		OR Cancelado = 1)
				AND		Autorizador_Ident	IS NOT NULL					

				SELECT	@CantidadTotal =	COUNT(1)
				FROM	app620.CatSolicitudEmpleadosAutorizantes 
				WHERE	FolioSolicitud		= @FolioSolicitud
				AND		Empleado_Ident		= @Empleado_Ident
				AND		ConceptoId			= @Concepto_Id	
				AND		Autorizador_Ident	IS NOT NULL					

				IF (
						@CantidadTotal = @CantidadTotalAC 
					AND 
						(ISNULL(@CantidadTotal, 0) <> 0)
					)
					BEGIN
						UPDATE CatEmpleadosSolicitudes
						SET EstatusSolicitudId	= 'A'
						WHERE	FolioSolicitud	= @FolioSolicitud
						AND		Empleado_Ident	= @Empleado_Ident
						AND		ConceptoId		= @Concepto_Id	
					END

				-- En esta sección se revisa si la solicitud Completa pasa a Autorizada				
				SELECT	 @CantidadTotal		= 0
						,@CantidadTotalAC	= 0

				SELECT	@CantidadTotalAC =	COUNT(1) 
				FROM	app620.CatEmpleadosSolicitudes 
				WHERE	FolioSolicitud		= @FolioSolicitud
				AND		EstatusSolicitudId	IN ('A', 'C')
				AND		Active				= 1

				SELECT	@CantidadTotal		= COUNT(1)
				FROM	app620.CatEmpleadosSolicitudes 
				WHERE	FolioSolicitud		= @FolioSolicitud
				AND		Active				= 1

				IF (
						@CantidadTotal = @CantidadTotalAC 
					AND 
						(ISNULL(@CantidadTotal, 0) <> 0)
					)
					BEGIN
						UPDATE app620.CatSolicitudes
						SET EstatusSolicitudId = 'A'
						WHERE	FolioSolicitud		= @FolioSolicitud
					END

				EXEC	[app620].[EnviaSolicitud] @FolioSolicitud
				--SELECT 'Se ejecuta EnviaSolicitud'
			END
		ELSE
			BEGIN
				UPDATE app620.CatEmpleadosSolicitudes
				SET EstatusSolicitudId	= 'R'
				FROM app620.CatSolicitudEmpleadosAutorizantes SEA 
				WHERE
					SEA.FolioSolicitud	= CatEmpleadosSolicitudes.FolioSolicitud
				AND SEA.Empleado_Ident	= CatEmpleadosSolicitudes.Empleado_Ident
				AND SEA.ConceptoId		= CatEmpleadosSolicitudes.ConceptoId
				AND SEA.Rechazado		= 1

				UPDATE app620.CatSolicitudes 
				SET EstatusSolicitudId = 'R'
				WHERE FolioSolicitud = @FolioSolicitud
			END

		---- En esta sección se revisa si la la solicitud Completa pasa a Autorizada

		--SELECT	@CantidadTotalAC =	COUNT(1) 
		--FROM	CatEmpleadosSolicitudes 
		--WHERE	FolioSolicitud		= @FolioSolicitud
		--AND		Empleado_Ident		= @Empleado_Ident
		--AND		ConceptoId			= @Concepto_Id
		--AND		EstatusSolicitudId	IN ('A', 'C')

		--SELECT	@CantidadTotal =	COUNT(1)
		--FROM	CatEmpleadosSolicitudes 
		--WHERE	FolioSolicitud		= @FolioSolicitud
		--AND		Empleado_Ident		= @Empleado_Ident
		--AND		ConceptoId			= @Concepto_Id						

		--IF (@CantidadTotal = @CantidadTotalAC)
		--	BEGIN
		--		UPDATE CatSolicitudes
		--		SET EstatusSolicitudId = 'A'
		--		WHERE	FolioSolicitud		= @FolioSolicitud
		--	END

	SELECT @Estatus

END
