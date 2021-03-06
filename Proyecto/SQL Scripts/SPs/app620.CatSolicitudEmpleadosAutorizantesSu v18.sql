USE [ASN_Ref]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudEmpleadosAutorizantesSu]    Script Date: 09/07/2020 11:34:51 a. m. ******/
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
		,@FolioSolicitudCur	INT = 0
		,@Empleado_IdentCur	INT = 0
		,@ConceptoIdCur		INT = 0
		,@NivelAutorizacionCur		INT = 0

	IF NOT EXISTS(
		SELECT 1 
		FROM app620.CatSolicitudEmpleadosAutorizantes 
		WHERE FolioSolicitud	= @FolioSolicitud 
		AND Empleado_Ident		= @Empleado_Ident 
		AND Autorizador_Ident	= @Autorizador_Ident
		AND NivelAutorizacion	= @NivelAutorizacion
	) AND (@Accion <> 5) AND (@Accion <> 6)
	SET @Estatus =-1
	--SELECT @Estatus Estatus

	IF(@Estatus =0)
		BEGIN
			UPDATE app620.CatSolicitudEmpleadosAutorizantes
			SET 
				 Pendiente	= (CASE WHEN @Accion = 1 THEN 1 ELSE 0 END)--Pendiente
				,Autorizado	= (CASE WHEN @Accion = 2 THEN 1 ELSE 0 END)--Autorizado
				,Rechazado	= (CASE WHEN @Accion = 3 THEN 1 ELSE 0 END)--Rechazado
				,Cancelado	= (CASE WHEN @Accion = 4 THEN 1 ELSE 0 END)--Cancelado
				--,Autorizado	= (CASE WHEN @Accion = 5 THEN 1 ELSE 0 END)--Autorizados todos
				--,Rechazado	= (CASE WHEN @Accion = 6 THEN 1 ELSE 0 END)--Rechazados todos
			WHERE
				FolioSolicitud		= @FolioSolicitud
			AND
				Empleado_Ident		= @Empleado_Ident
			AND
				(ConceptoId			= @Concepto_Id			)--OR	@Accion = 5)
			AND
				(NivelAutorizacion	= @NivelAutorizacion	)--OR	@Accion = 5)
			AND
				(Autorizador_Ident	= @Autorizador_Ident	)--OR	@Accion = 5)
		END

	IF (@Accion = 3)
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

	ELSE IF (@Accion = 5)

		BEGIN
			 CREATE TABLE #TempSolicitudEmpleadosAutorizantesTable(
				 FolioSolicitud					int
				,Empleado_Ident					int
				,ConceptoId						int
				,NivelAutorizacion				int
				,CantidadTotalR					int  NULL
				,CantidadTotalAC				int  NULL
				,CantidadTotal					int  NULL
				,ComparacionCantidadTotal		int  NULL
				,CantidadFolioTotalAC			int  NULL
				,CantidadFolioTotal				int  NULL
				,ComparacionCantidadFolioTotal	int  NULL
			)

		--BEGIN TRAN
			-- Calcular todos los SolicitudEmpleadosAutorizantes del Solicitante actual en estatus de Pendiente
			INSERT INTO #TempSolicitudEmpleadosAutorizantesTable (FolioSolicitud,Empleado_Ident,ConceptoId,NivelAutorizacion) 
			SELECT	FolioSolicitud,Empleado_Ident,ConceptoId,NivelAutorizacion--,Autorizador_Ident,Pendiente,Autorizado,Rechazado,Cancelado
			FROM	[app620].[CatSolicitudEmpleadosAutorizantes]
			WHERE	FolioSolicitud = @FolioSolicitud
					AND Autorizador_Ident IS NOT NULL
					AND Autorizador_Ident = @Autorizador_Ident --666386						
					AND (Pendiente = 1)

			-- Autorizar todos los SolicitudEmpleadosAutorizantes del Solicitante actual en estatus de Penidente
			UPDATE app620.CatSolicitudEmpleadosAutorizantes
			SET 
				 Pendiente = 0
				,Autorizado	=  1 --Autorizado
			FROM [app620].[CatSolicitudEmpleadosAutorizantes]
			JOIN #TempSolicitudEmpleadosAutorizantesTable Aut
			ON
				CatSolicitudEmpleadosAutorizantes.FolioSolicitud		= Aut.FolioSolicitud
			AND
				CatSolicitudEmpleadosAutorizantes.Empleado_Ident		= Aut.Empleado_Ident
			AND
				(CatSolicitudEmpleadosAutorizantes.ConceptoId			= Aut.ConceptoId		)--OR	@Accion = 5)
			AND
				(CatSolicitudEmpleadosAutorizantes.NivelAutorizacion	= Aut.NivelAutorizacion	)--OR	@Accion = 5)

			DECLARE EmpleadosSolicitudesTemp CURSOR
				FOR SELECT DISTINCT  FolioSolicitud
					,Empleado_Ident
					,ConceptoId
				FROM #TempSolicitudEmpleadosAutorizantesTable

			OPEN EmpleadosSolicitudesTemp;

			FETCH NEXT FROM EmpleadosSolicitudesTemp INTO @FolioSolicitudCur,@Empleado_IdentCur,@ConceptoIdCur;

			WHILE @@FETCH_STATUS = 0  
				BEGIN

				-- En esta sección se revisa si el concepto de la solicitud pasa a Autorizado
				SELECT	@CantidadTotalAC =	COUNT(1)
				FROM	app620.CatSolicitudEmpleadosAutorizantes
				WHERE	FolioSolicitud		= @FolioSolicitudCur
				AND		Empleado_Ident		= @Empleado_IdentCur
				AND		ConceptoId			= @ConceptoIdCur
				AND		(Autorizado = 1		OR Cancelado = 1)
				AND		Autorizador_Ident	IS NOT NULL	

				SELECT	@CantidadTotal =	COUNT(1)
				FROM	app620.CatSolicitudEmpleadosAutorizantes
				WHERE	FolioSolicitud		= @FolioSolicitudCur
				AND		Empleado_Ident		= @Empleado_IdentCur
				AND		ConceptoId			= @ConceptoIdCur
				AND		Autorizador_Ident	IS NOT NULL		

				IF (
						@CantidadTotal = @CantidadTotalAC 
					AND 
						(ISNULL(@CantidadTotal, 0) <> 0)
					)
					BEGIN

						UPDATE CatEmpleadosSolicitudes
						SET EstatusSolicitudId	= 'A'
						WHERE	FolioSolicitud	= @FolioSolicitudCur
						AND		Empleado_Ident	= @Empleado_IdentCur
						AND		ConceptoId		= @ConceptoIdCur	
					END

				-- En esta sección se revisa si la solicitud Completa pasa a Autorizada				
				SELECT	 @CantidadTotal		= 0
						,@CantidadTotalAC	= 0

				SELECT	@CantidadTotalAC =	COUNT(1) 
				FROM	app620.CatEmpleadosSolicitudes 
				WHERE	FolioSolicitud		= @FolioSolicitudCur
				AND		EstatusSolicitudId	IN ('A', 'C')
				AND		Active				= 1

				SELECT	@CantidadTotal		= COUNT(1)
				FROM	app620.CatEmpleadosSolicitudes 
				WHERE	FolioSolicitud		= @FolioSolicitudCur
				AND		Active				= 1

				IF (
						@CantidadTotal = @CantidadTotalAC 
					AND 
						(ISNULL(@CantidadTotal, 0) <> 0)
					)
					BEGIN
						UPDATE app620.CatSolicitudes
						SET EstatusSolicitudId = 'A'
						WHERE	FolioSolicitud		= @FolioSolicitudCur
					END

					FETCH NEXT FROM EmpleadosSolicitudesTemp INTO @FolioSolicitudCur,@Empleado_IdentCur,@ConceptoIdCur;  
				END;

			CLOSE EmpleadosSolicitudesTemp;

			DEALLOCATE EmpleadosSolicitudesTemp;

			EXEC	[app620].[EnviaSolicitud] @FolioSolicitud
					
			DROP TABLE #TempSolicitudEmpleadosAutorizantesTable
		END

	ELSE IF (@Accion = 6)

		BEGIN
			 CREATE TABLE #TempSolicitudEmpleadosAutorizantesTableR(
				 FolioSolicitud					int
				,Empleado_Ident					int
				,ConceptoId						int
				,NivelAutorizacion				int
				--,CantidadTotalR					int  NULL
				--,CantidadTotalAC				int  NULL
				--,CantidadTotal					int  NULL
				--,ComparacionCantidadTotal		int  NULL
				--,CantidadFolioTotalAC			int  NULL
				--,CantidadFolioTotal				int  NULL
				--,ComparacionCantidadFolioTotal	int  NULL
			)

		--BEGIN TRAN
			-- Calcular todos los SolicitudEmpleadosAutorizantes del Solicitante actual en estatus de Penidente
			INSERT INTO #TempSolicitudEmpleadosAutorizantesTableR (FolioSolicitud,Empleado_Ident,ConceptoId,NivelAutorizacion) 
			SELECT	FolioSolicitud,Empleado_Ident,ConceptoId,NivelAutorizacion--,Autorizador_Ident,Pendiente,Autorizado,Rechazado,Cancelado
			FROM	[app620].[CatSolicitudEmpleadosAutorizantes]
			WHERE	FolioSolicitud = @FolioSolicitud
					AND Autorizador_Ident IS NOT NULL
					AND Autorizador_Ident = @Autorizador_Ident --666386						
					AND (Pendiente = 1)

			-- Autorizar todos los SolicitudEmpleadosAutorizantes del Solicitante actual en estatus de Penidente
			UPDATE app620.CatSolicitudEmpleadosAutorizantes
			SET 
				 Pendiente = 0
				,Rechazado	=  1 --Rechazado
			FROM [app620].[CatSolicitudEmpleadosAutorizantes]
			JOIN #TempSolicitudEmpleadosAutorizantesTableR Aut
			ON
				CatSolicitudEmpleadosAutorizantes.FolioSolicitud		= Aut.FolioSolicitud
			AND
				CatSolicitudEmpleadosAutorizantes.Empleado_Ident		= Aut.Empleado_Ident
			AND
				(CatSolicitudEmpleadosAutorizantes.ConceptoId			= Aut.ConceptoId		)--OR	@Accion = 5)
			AND
				(CatSolicitudEmpleadosAutorizantes.NivelAutorizacion	= Aut.NivelAutorizacion	)--OR	@Accion = 5)

			DECLARE EmpleadosSolicitudesTemp CURSOR
				FOR SELECT DISTINCT  FolioSolicitud
					,Empleado_Ident
					,ConceptoId
					,NivelAutorizacion
				FROM #TempSolicitudEmpleadosAutorizantesTableR

			OPEN EmpleadosSolicitudesTemp;

			FETCH NEXT FROM EmpleadosSolicitudesTemp INTO @FolioSolicitudCur,@Empleado_IdentCur,@ConceptoIdCur,@NivelAutorizacionCur;

			WHILE @@FETCH_STATUS = 0  
				BEGIN

				-- En esta sección se revisa si el concepto de la solicitud pasa a Rechazado
				SELECT	@Estatus			=	Rechazado
				FROM	app620.CatSolicitudEmpleadosAutorizantes
				WHERE	FolioSolicitud		= @FolioSolicitudCur
				AND		Empleado_Ident		= @Empleado_IdentCur
				AND		ConceptoId			= @ConceptoIdCur
				AND		NivelAutorizacion	= @NivelAutorizacionCur
				AND		Rechazado = 1
				AND		Autorizador_Ident	IS NOT NULL	

				IF (
						@Estatus = 1 
					)
					BEGIN
						-- En esta sección se revisa si el concepto de la solicitud pasa a Rechazada				
						UPDATE CatEmpleadosSolicitudes
						SET EstatusSolicitudId	= 'R'
						WHERE	FolioSolicitud	= @FolioSolicitudCur
						AND		Empleado_Ident	= @Empleado_IdentCur
						AND		ConceptoId		= @ConceptoIdCur

						-- En esta sección se revisa si la solicitud Completa pasa a Rechazada				
						UPDATE app620.CatSolicitudes
						SET EstatusSolicitudId	= 'R'
						WHERE	FolioSolicitud	= @FolioSolicitudCur

					END

					FETCH NEXT FROM EmpleadosSolicitudesTemp INTO @FolioSolicitudCur,@Empleado_IdentCur,@ConceptoIdCur,@NivelAutorizacionCur;  
				END;

			CLOSE EmpleadosSolicitudesTemp;

			DEALLOCATE EmpleadosSolicitudesTemp;

			EXEC	[app620].[EnviaSolicitud] @FolioSolicitud
					
			--ROLLBACK TRAN

			--DROP TABLE #TempCatEmpleadosSolicitudesTable

			DROP TABLE #TempSolicitudEmpleadosAutorizantesTableR
		END

	IF (@Accion <> 3 AND @Accion <> 5 AND @Accion <> 6)
		-- Se actualiza la nueva solicitud Pendiente
		BEGIN
			--SELECT 'Seccion @Accion <> 3'
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
					--SELECT *
					--FROM CatEmpleadosSolicitudes
					----SET EstatusSolicitudId	= 'A'
					--WHERE	FolioSolicitud	= @FolioSolicitud
					--AND		Empleado_Ident	= @Empleado_Ident
					--AND		ConceptoId		= @Concepto_Id

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

	SELECT @Estatus

END