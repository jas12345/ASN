USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatAutorizacionesSel]    Script Date: 23/07/2019 11:49:47 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatAutorizacionesSel]
	 @FolioSolicitud INT = 0
	,@Autorizante_Ident	INT = 0
AS
BEGIN

	SET @FolioSolicitud = ISNULL(@FolioSolicitud, 0)

	DECLARE @Temp TABLE(
		 FolioSolicitud		INT NULL
		,Empleado_Ident		INT NULL
		,ConceptoId			INT NULL
		,NivelAutorizacion	INT NULL
		,Autorizador_Ident	INT NULL
	)

	--INSERT INTO @Temp
	--SELECT FolioSolicitud
	--	,Empleado_Ident	
	--	,ConceptoId		
	--	,NivelAutorizacion
	--	,Autorizador_Ident
	--FROM CatSolicitudEmpleadosAutorizantes 

	SELECT
		 Sol.[FolioSolicitud]
		,Sol.Solicitante_Ident
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
		,SEA.NivelAutorizacion
		,EmpSol.Active

	FROM [ASN].[app620].[CatSolicitudes] Sol

	JOIN [ASN].[app620].[CatEmpleadosSolicitudes] EmpSol 
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

	JOIN [app620].[CatSolicitudEmpleadosDetalle] SED
		ON SED.FolioSolicitud = Empsol.FolioSolicitud
		AND SED.[Empleado_Ident] = Empsol.[Empleado_Ident]
		AND SED.[ConceptoId] = Empsol.[ConceptoId]
		AND SED.Active = 1

	JOIN app620.CatSolicitudEmpleadosAutorizantes SEA
		ON SEA.FolioSolicitud = Empsol.FolioSolicitud
		AND SEA.[Empleado_Ident] = Empsol.[Empleado_Ident]
		AND SEA.[ConceptoId] = Empsol.[ConceptoId]
		AND SEA.Pendiente = 1
		AND SEA.Autorizador_Ident = @Autorizante_Ident

	LEFT JOIN app620.CatEmployeeCCMSVw EMP2 
		ON EMP2.Ident = SED.ResponsableId

	LEFT JOIN [app620].[CatConceptosMotivos] ConMot
		ON ConMot.ConceptoMotivoId = SED.ConceptoMotivoId

	WHERE Sol.[Active] = 1
	AND EmpSol.Active = 1
    AND (Sol.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

	-- WHERE CS.[Active] = 1
	-- AND (CS.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

END
