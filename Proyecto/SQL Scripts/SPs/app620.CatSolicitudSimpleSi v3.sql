USE [ASN7]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudSimpleSi]    Script Date: 20/04/2020 08:48:05 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatSolicitudSimpleSi]
	 @FolioSolicitud INT = NULL
	,@EmployeeId INT 
	,@ConceptoPS VARCHAR(12)
	,@ConceptoMonto DECIMAL(18,2) = NULL

	,@UserEmployeeId INT = NULL

	,@FolioSolicitudOut INT = -1 OUTPUT
	,@Estatus INT = 0 OUTPUT

AS
BEGIN
	
	DECLARE @idSolicitud INT =0
	DECLARE @FechaActual DATETIME
	DECLARE  @EstatusSolicitud VARCHAR(5) = 'EB'
			,@Autorizador1 INT = NULL
			,@Autorizador2 INT = NULL
			,@Autorizador3 INT = NULL
			,@Autorizador4 INT = NULL
			,@Autorizador5 INT = NULL
			,@Autorizador6 INT = NULL
			,@Autorizador7 INT = NULL
			,@Autorizador8 INT = NULL
			,@Autorizador9 INT = NULL
			,@ConceptoId INT = -1
			,@PeriodoNomina_Id INT = 0
			,@Active BIT = 1
	
	DECLARE
		 @CantidadTotal		INT = 0

	DECLARE @NivelesAutorizacionxEmpleadoxConcepto table(
		 Nivel	INT
		,Id		INT
		,Valor	VARCHAR(752)
	)

	SELECT @FechaActual = GETDATE();
	--SELECT @Estatus = ISNULL(@Estatus, 0);

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
		 0 = Proceso sin error
		-2 = Ya existe un registro con este Empleado y Concepto.
	*/

	SELECT @FolioSolicitudOut	= @FolioSolicitud

	--SELECT @PeriodoNomina_Id = PeriodoNomina_Id
	--FROM app620.catperioodonomina
	--ORDER BY fechaCaptura

	SELECT TOP 1
		 @PeriodoNomina_Id = PeriodoNominaId
	FROM [app620].[CatPeriodosNomina]
	WHERE 
				FechaCaptura >= getdate()
	ORDER BY FechaCaptura DESC

	IF EXISTS	(
					SELECT 1
					FROM app620.CatSolicitudes
					WHERE					
						FolioSolicitud	= @FolioSolicitud
				)
		BEGIN
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
				,PeriodoNominaId
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
				,@PeriodoNomina_Id
				,'EB'
				,@UserEmployeeId
				,@FechaActual
				,@UserEmployeeId
				,@FechaActual
			)
				
			SELECT TOP 1 @FolioSolicitudOut = FolioSolicitud FROM @inserted;
		END

	SELECT @Estatus = @FolioSolicitudOut

	SELECT	@ConceptoId = C.ConceptoId
	FROM	CatConceptos C
	JOIN	app620.CatConceptosPeopleSoft CCPS
		ON CCPS.ConceptoId = C.PeopleSoftId
	WHERE
		CCPS.Descripcion = @ConceptoPS
	AND		@ConceptoPS IN (
					'COMEDOR CVO'
				,'COMEDOR TP1'
				,'COMEDOR TP2'
				,'COMEDOR TP4'
				,'COMEDOR TPDO'
			)

	INSERT INTO @NivelesAutorizacionxEmpleadoxConcepto
    EXECUTE [app620].[NivelesAutorizacionxEmpleadoxConcepto] 
		 @EmpleadoIdent	= @EmployeeId
		,@ConceptoId	= @ConceptoId
		,@FolioId		= -1

	SELECT	@ConceptoId --= ISNULL(@ConceptoId, 0)

	IF (@ConceptoId		<> -1)
	BEGIN
		IF NOT EXISTS(
					SELECT 1 FROM CatEmpleadosSolicitudes 
					WHERE
						FolioSolicitud	= @FolioSolicitud
					AND
						Empleado_Ident	= @EmployeeId
					AND
						ConceptoId		= @ConceptoId
					AND
						@ConceptoId		<> -1
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
					,3					-- Motivo: N/A
					,@Active
					,@UserEmployeeId
					,@FechaActual
					,@UserEmployeeId
					,@FechaActual
				)
			END

		INSERT INTO @NivelesAutorizacionxEmpleadoxConcepto
		EXECUTE [app620].[NivelesAutorizacionxEmpleadoxConcepto] 
			 @EmpleadoIdent	= @EmployeeId
			,@ConceptoId	= @ConceptoId
			,@FolioId		= -1

		SELECT	@Autorizador1	= Id
		FROM	@NivelesAutorizacionxEmpleadoxConcepto
		WHERE	Nivel = 1

		SELECT	@Autorizador2	= Id
		FROM	@NivelesAutorizacionxEmpleadoxConcepto
		WHERE	Nivel = 2

		SELECT	@Autorizador3	= Id
		FROM	@NivelesAutorizacionxEmpleadoxConcepto
		WHERE	Nivel = 3

		SELECT	@Autorizador4	= Id
		FROM	@NivelesAutorizacionxEmpleadoxConcepto
		WHERE	Nivel = 4

		SELECT	@Autorizador5	= Id
		FROM	@NivelesAutorizacionxEmpleadoxConcepto
		WHERE	Nivel = 5

		SELECT	@Autorizador6	= Id
		FROM	@NivelesAutorizacionxEmpleadoxConcepto
		WHERE	Nivel = 6

		SELECT	@Autorizador7	= Id
		FROM	@NivelesAutorizacionxEmpleadoxConcepto
		WHERE	Nivel = 7

		SELECT	@Autorizador8	= Id
		FROM	@NivelesAutorizacionxEmpleadoxConcepto
		WHERE	Nivel = 8

		SELECT	@Autorizador9	= Id
		FROM	@NivelesAutorizacionxEmpleadoxConcepto
		WHERE	Nivel = 9

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
	END
END