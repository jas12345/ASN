USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudesSel]    Script Date: 14/07/2019 11:27:45 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatSolicitudesSel]
	@FolioSolicitud INT = 0
AS
BEGIN

	SET @FolioSolicitud = ISNULL(@FolioSolicitud, 0)

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
		,ConMot.Descripcion ConceptoMotivoDesc
		,ISNULL(SED.ResponsableId, 0) ResponsableId
		,ISNULL(SED.PeriodoOriginalId, -1) PeriodoOriginalId
		,SEA1.NivelAutorizacion NivelAutorizacion1
		,SEA1.Autorizador_Ident AutorizadorNivel1
		,SEA2.NivelAutorizacion NivelAutorizacion2
		,SEA2.Autorizador_Ident AutorizadorNivel2
		,SEA3.NivelAutorizacion NivelAutorizacion3
		,SEA3.Autorizador_Ident AutorizadorNivel3
		,SEA4.NivelAutorizacion NivelAutorizacion4
		,SEA4.Autorizador_Ident AutorizadorNivel4
		,SEA5.NivelAutorizacion NivelAutorizacion5
		,SEA5.Autorizador_Ident AutorizadorNivel5
		,SEA6.NivelAutorizacion NivelAutorizacion6
		,SEA6.Autorizador_Ident AutorizadorNivel6
		--,SEA7.NivelAutorizacion NivelAutorizacion7
		--,SEA7.Autorizador_Ident Autorizador7_Ident
		--,SEA8.NivelAutorizacion NivelAutorizacion8
		--,SEA8.Autorizador_Ident Autorizador8_Ident
		--,SEA9.NivelAutorizacion NivelAutorizacion9
		--,SEA9.Autorizador_Ident Autorizador9_Ident
		,EmpSol.Active
	FROM [ASN].[app620].[CatSolicitudes] Sol

	LEFT JOIN [ASN].[app620].[CatEmpleadosSolicitudes] EmpSol 
		ON empSol.FolioSolicitud = sol.FolioSolicitud

	LEFT JOIN [app620].[CatSolicitudEmpleadosDetalle] SED
		ON SED.FolioSolicitud = Empsol.FolioSolicitud
		AND SED.[Empleado_Ident] = Empsol.[Empleado_Ident]
		AND SED.[ConceptoId] = Empsol.[ConceptoId]
		AND SED.Active = 1

	LEFT JOIN app620.CatEmployeeCCMSVw EMP 
		ON EMP.Ident = EmpSol.[Empleado_Ident]

	LEFT JOIN [app620].[CatConceptos] Con
		ON Con.ConceptoId = EmpSol.ConceptoId

	LEFT JOIN [app620].[CatConceptosMotivos] ConMot
		ON ConMot.ConceptoMotivoId = SED.ConceptoMotivoId

    LEFT JOIN [app620].[CatMotivosSolicitud] CMS 
		ON CMS.MotivosSolicitudId = EmpSol.MotivosSolicitudId

	JOIN app620.CatParametroConceptos Par
		ON Par.[ParametroConceptoId] = Con.ParametroConceptoId

	JOIN CatSolicitudEmpleadosAutorizantes SEA1
		ON	SEA1.FolioSolicitud		= SED.FolioSolicitud
		AND SEA1.Empleado_Ident		= SED.Empleado_Ident
		AND SEA1.ConceptoId			= SED.ConceptoId
		AND SEA1.NivelAutorizacion	= 1

	JOIN CatSolicitudEmpleadosAutorizantes SEA2
		ON	SEA2.FolioSolicitud		= SED.FolioSolicitud
		AND SEA2.Empleado_Ident		= SED.Empleado_Ident
		AND SEA2.ConceptoId			= SED.ConceptoId
		AND SEA2.NivelAutorizacion	= 2

	JOIN CatSolicitudEmpleadosAutorizantes SEA3
		ON	SEA3.FolioSolicitud		= SED.FolioSolicitud
		AND SEA3.Empleado_Ident		= SED.Empleado_Ident
		AND SEA3.ConceptoId			= SED.ConceptoId
		AND SEA3.NivelAutorizacion	= 3

	JOIN CatSolicitudEmpleadosAutorizantes SEA4
		ON	SEA4.FolioSolicitud		= SED.FolioSolicitud
		AND SEA4.Empleado_Ident		= SED.Empleado_Ident
		AND SEA4.ConceptoId			= SED.ConceptoId
		AND SEA4.NivelAutorizacion	= 4

	JOIN CatSolicitudEmpleadosAutorizantes SEA5
		ON	SEA5.FolioSolicitud		= SED.FolioSolicitud
		AND SEA5.Empleado_Ident		= SED.Empleado_Ident
		AND SEA5.ConceptoId			= SED.ConceptoId
		AND SEA5.NivelAutorizacion	= 5

	JOIN CatSolicitudEmpleadosAutorizantes SEA6
		ON	SEA6.FolioSolicitud		= SED.FolioSolicitud
		AND SEA6.Empleado_Ident		= SED.Empleado_Ident
		AND SEA6.ConceptoId			= SED.ConceptoId
		AND SEA6.NivelAutorizacion	= 6

	--JOIN CatSolicitudEmpleadosAutorizantes SEA7
	--	ON	SEA7.FolioSolicitud		= SED.FolioSolicitud
	--	AND SEA7.Empleado_Ident		= SED.Empleado_Ident
	--	AND SEA7.ConceptoId			= SED.ConceptoId
	--	AND SEA7.NivelAutorizacion	= 7

	--JOIN CatSolicitudEmpleadosAutorizantes SEA8
	--	ON	SEA8.FolioSolicitud		= SED.FolioSolicitud
	--	AND SEA8.Empleado_Ident		= SED.Empleado_Ident
	--	AND SEA8.ConceptoId			= SED.ConceptoId
	--	AND SEA8.NivelAutorizacion	= 8

	--JOIN CatSolicitudEmpleadosAutorizantes SEA9
	--	ON	SEA9.FolioSolicitud		= SED.FolioSolicitud
	--	AND SEA9.Empleado_Ident		= SED.Empleado_Ident
	--	AND SEA9.ConceptoId			= SED.ConceptoId
	--	AND SEA9.NivelAutorizacion	= 9

	WHERE Sol.[Active] = 1
	AND EmpSol.Active = 1
    AND (Sol.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

 -- WHERE CS.[Active] = 1
 -- AND (CS.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

END