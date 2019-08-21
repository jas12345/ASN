ALTER PROC [app620].[CatSolicitudesSel]
	@FolioSolicitud INT = 0
AS
BEGIN

	SET @FolioSolicitud = ISNULL(@FolioSolicitud, 0)

	--DECLARE @Temp TABLE(
	--	 FolioSolicitud		INT NULL
	--	,Empleado_Ident		INT NULL
	--	,ConceptoId			INT NULL
	--	,NivelAutorizacion	INT NULL
	--	,Autorizador_Ident	INT NULL
	--)

	--INSERT INTO @Temp
	--SELECT FolioSolicitud
	--	,Empleado_Ident	
	--	,ConceptoId		
	--	,NivelAutorizacion
	--	,Autorizador_Ident
	--FROM app620.CatSolicitudEmpleadosAutorizantes 
	--where FolioSolicitud = @FolioSolicitud

	DECLARE @TempAutorizantes AS TABLE (FolioSolicitud INT,Empleado_Ident INT, ConceptoId INT, Autorizador_Ident INT,Pendiente BIT, Autorizado BIT, Rechazado BIT, Cancelado BIT)

	INSERT	INTO @TempAutorizantes(FolioSolicitud,Empleado_Ident,ConceptoId,Autorizador_Ident,Pendiente,Autorizado,Rechazado,Cancelado)
	SELECT	FolioSolicitud,Empleado_Ident,ConceptoId,Autorizador_Ident,Pendiente,Autorizado,Rechazado,Cancelado
	FROM	[app620].[CatSolicitudEmpleadosAutorizantes]
	WHERE	FolioSolicitud = @FolioSolicitud
			AND Autorizador_Ident IS NOT NULL
			AND (Pendiente = 1 OR Rechazado = 1 OR Cancelado = 1)


	SELECT
		 Sol.[FolioSolicitud]
		,EMP.Ident
		,EMP.Nombre
		,Con.ConceptoId
		,Con.Descripcion ConceptoDesc
		,CONVERT(VARCHAR(22), ParametroConceptoMonto) + ' ' +  Par.Descripcion Monto
		,CMS.MotivosSolicitudId
		,CMS.Descripcion MotivosSolicitudDesc
		,ISNULL(ConMot.ConceptoMotivoId, -1) ConceptoMotivoId
		--,ConMot.ConceptoMotivoId
		,ConMot.Descripcion ConceptoMotivoDesc
		,ISNULL(SED.ResponsableId, 0) ResponsableId
		--,SED.ResponsableId
		,EMP2.Nombre NombreResponsable
		,ISNULL(SED.PeriodoOriginalId, -1) PeriodoOriginalId
		--,SED.PeriodoOriginalId
		,ES.EstatusSolicitudId EstatusId
		,ES.Descripcion EstatusSolicitud
		--,SEA1.NivelAutorizacion NivelAutorizacion1
		--,SEA1.Autorizador_Ident AutorizadorNivel1
		--,SEA2.NivelAutorizacion NivelAutorizacion2
		--,SEA2.Autorizador_Ident AutorizadorNivel2
		--,SEA3.NivelAutorizacion NivelAutorizacion3
		--,SEA3.Autorizador_Ident AutorizadorNivel3
		--,SEA4.NivelAutorizacion NivelAutorizacion4
		--,SEA4.Autorizador_Ident AutorizadorNivel4
		--,NULL NivelAutorizacion5
		--,NULL AutorizadorNivel5
		--,NULL NivelAutorizacion6
		--,NULL AutorizadorNivel6
		--,NULL NivelAutorizacion7
		--,NULL Autorizador7_Ident
		--,NULL NivelAutorizacion8
		--,NULL Autorizador8_Ident
		--,NULL NivelAutorizacion9
		--,NULL Autorizador9_Ident
		,EmpSol.Active
		,SEA.Autorizador_Ident
		,AUT.Nombre Autorizador		
	FROM [app620].[CatSolicitudes] Sol

	JOIN [app620].[CatEmpleadosSolicitudes] EmpSol 
		ON empSol.FolioSolicitud = sol.FolioSolicitud

	JOIN app620.CatEstatusSolicitudes ES
		ON ES.EstatusSolicitudId = EmpSol.EstatusSolicitudId

	JOIN app620.CatEmployeeCCMSVw EMP 
		ON EMP.Ident = EmpSol.[Empleado_Ident]

	JOIN [app620].[CatConceptos] Con
		ON Con.ConceptoId = EmpSol.ConceptoId

	JOIN app620.CatParametroConceptos Par
		ON Par.[ParametroConceptoId] = Con.ParametroConceptoId

    LEFT JOIN [app620].[CatMotivosSolicitud] CMS 
		ON CMS.MotivosSolicitudId = EmpSol.MotivosSolicitudId

	LEFT JOIN [app620].[CatSolicitudEmpleadosDetalle] SED
		ON SED.FolioSolicitud = Empsol.FolioSolicitud
		AND SED.[Empleado_Ident] = Empsol.[Empleado_Ident]
		AND SED.[ConceptoId] = Empsol.[ConceptoId]
		AND SED.Active = 1

	LEFT JOIN app620.CatEmployeeCCMSVw EMP2 
		ON EMP2.Ident = SED.ResponsableId

	LEFT JOIN [app620].[CatConceptosMotivos] ConMot
		ON ConMot.ConceptoMotivoId = SED.ConceptoMotivoId

	LEFT JOIN @TempAutorizantes SEA 
		ON	SEA.FolioSolicitud = Sol.FolioSolicitud 
			AND Con.ConceptoId = SEA.ConceptoId

	LEFT JOIN [app620].[CatEmployeeCCMSVw] AUT 
		ON	AUT.Ident = SEA.Autorizador_Ident

	--JOIN @Temp SEA1
	--	ON	SEA1.FolioSolicitud		= Empsol.FolioSolicitud
	--	AND SEA1.Empleado_Ident		= Empsol.Empleado_Ident
	--	AND SEA1.ConceptoId			= Empsol.ConceptoId
	--	AND SEA1.NivelAutorizacion	= 1

	--JOIN @Temp SEA2
	--	ON	SEA2.FolioSolicitud		= Empsol.FolioSolicitud
	--	AND SEA2.Empleado_Ident		= Empsol.Empleado_Ident
	--	AND SEA2.ConceptoId			= Empsol.ConceptoId
	--	AND SEA2.NivelAutorizacion	= 2

	--JOIN @Temp SEA3
	--	ON	SEA3.FolioSolicitud		= Empsol.FolioSolicitud
	--	AND SEA3.Empleado_Ident		= Empsol.Empleado_Ident
	--	AND SEA3.ConceptoId			= Empsol.ConceptoId
	--	AND SEA3.NivelAutorizacion	= 3

	--JOIN @Temp SEA4
	--	ON	SEA4.FolioSolicitud		= Empsol.FolioSolicitud
	--	AND SEA4.Empleado_Ident		= Empsol.Empleado_Ident
	--	AND SEA4.ConceptoId			= Empsol.ConceptoId
	--	AND SEA4.NivelAutorizacion	= 4

	--JOIN CatSolicitudEmpleadosAutorizantes SEA5
	--	ON	SEA5.FolioSolicitud		= Empsol.FolioSolicitud
	--	AND SEA5.Empleado_Ident		= Empsol.Empleado_Ident
	--	AND SEA5.ConceptoId			= Empsol.ConceptoId
	--	AND SEA5.NivelAutorizacion	= 5

	--JOIN CatSolicitudEmpleadosAutorizantes SEA6
	--	ON	SEA6.FolioSolicitud		= Empsol.FolioSolicitud
	--	AND SEA6.Empleado_Ident		= Empsol.Empleado_Ident
	--	AND SEA6.ConceptoId			= Empsol.ConceptoId
	--	AND SEA6.NivelAutorizacion	= 6

	--JOIN CatSolicitudEmpleadosAutorizantes SEA7
	--	ON	SEA7.FolioSolicitud		= Empsol.FolioSolicitud
	--	AND SEA7.Empleado_Ident		= Empsol.Empleado_Ident
	--	AND SEA7.ConceptoId			= Empsol.ConceptoId
	--	AND SEA7.NivelAutorizacion	= 7

	--JOIN CatSolicitudEmpleadosAutorizantes SEA8
	--	ON	SEA8.FolioSolicitud		= Empsol.FolioSolicitud
	--	AND SEA8.Empleado_Ident		= Empsol.Empleado_Ident
	--	AND SEA8.ConceptoId			= Empsol.ConceptoId
	--	AND SEA8.NivelAutorizacion	= 8

	--JOIN CatSolicitudEmpleadosAutorizantes SEA9
	--	ON	SEA9.FolioSolicitud		= Empsol.FolioSolicitud
	--	AND SEA9.Empleado_Ident		= Empsol.Empleado_Ident
	--	AND SEA9.ConceptoId			= Empsol.ConceptoId
	--	AND SEA9.NivelAutorizacion	= 9

	WHERE Sol.[Active] = 1
	AND EmpSol.Active = 1
    AND (Sol.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

	-- WHERE CS.[Active] = 1
	-- AND (CS.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

END

