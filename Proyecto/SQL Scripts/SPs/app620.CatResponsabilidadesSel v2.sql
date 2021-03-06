USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatAutorizacionesSel]    Script Date: 05/08/2019 12:54:33 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatResponsabilidadesSel]
	 @FolioSolicitud INT = 0
	,@Responsable_Ident	INT = 0
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

	SELECT
		 Sol.[FolioSolicitud]
		,Sol.Solicitante_Ident
		,EMP.Ident
		,EMP.Nombre
		,Con.ConceptoId
		,Con.Descripcion ConceptoDesc
		,CONVERT(VARCHAR(22), EmpSol.ParametroConceptoMonto) + ' ' +  Par.Descripcion Monto
		,CMS.MotivosSolicitudId
		,CMS.Descripcion MotivosSolicitudDesc
		,ISNULL(ConMot.ConceptoMotivoId, -1) ConceptoMotivoId
		,ConMot.ConceptoMotivoId
		,ConMot.Descripcion ConceptoMotivoDesc
		,ISNULL(SED.ResponsableId, 0) ResponsableId
		,SED.ResponsableId
		,EMP2.Nombre NombreResponsable
		,ISNULL(SED.PeriodoOriginalId, -1) PeriodoOriginalId
		,SED.PeriodoOriginalId
		,ES.EstatusSolicitudId EstatusId
		,ES.Descripcion EstatusSolicitud
		--,SEA.NivelAutorizacion
		,EmpSol.Active

	FROM
		app620.CatSolicitudes Sol

	JOIN [ASN2].[app620].[CatEmpleadosSolicitudes] EmpSol 
		ON EmpSol.FolioSolicitud = Sol.FolioSolicitud
	    --AND Sol.FolioSolicitud = @FolioSolicitud
	    AND Sol.FolioSolicitud = 10
		AND Sol.Active = 1
		AND EmpSol.Active = 1

	JOIN app620.CatEstatusSolicitudes ES
		ON ES.EstatusSolicitudId = EmpSol.EstatusSolicitudId

	JOIN app620.CatEmployeeCCMSVw EMP 
		ON EMP.Ident = Sol.Solicitante_Ident

	JOIN app620.CatConceptos Con
		ON Con.ConceptoId = EmpSol.ConceptoId

	JOIN app620.CatParametroConceptos Par
		ON Par.[ParametroConceptoId] = Con.ParametroConceptoId

    LEFT JOIN app620.CatMotivosSolicitud CMS 
		ON CMS.MotivosSolicitudId = EmpSol.MotivosSolicitudId

	LEFT JOIN app620.CatSolicitudEmpleadosDetalle SED
		ON SED.FolioSolicitud		= Empsol.FolioSolicitud
		AND SED.[Empleado_Ident]	= Empsol.[Empleado_Ident]
		AND SED.[ConceptoId]		= Empsol.[ConceptoId]
		AND SED.Active = 1

	--------JOIN app620.CatSolicitudEmpleadosAutorizantes SEA
	--------	ON SEA.FolioSolicitud		= Empsol.FolioSolicitud
	--------	AND SEA.[Empleado_Ident]	= Empsol.[Empleado_Ident]
	--------	AND SEA.[ConceptoId]		= Empsol.[ConceptoId]
	--------	AND SEA.Autorizador_Ident	IS NOT NULL
		--AND SEA.Pendiente = 1
		--AND SEA.Autorizador_Ident = @Responsable_Ident

	LEFT JOIN app620.CatEmployeeCCMSVw EMP2 
		ON EMP2.Ident = SED.ResponsableId
		
	LEFT JOIN app620.CatConceptosMotivos ConMot
		ON ConMot.ConceptoMotivoId = SED.ConceptoMotivoId

	JOIN app620.CatPerfilEmpleadosAccesos PEAR
		ON
			--PEAR.EmpleadoId		= @Responsable_Ident
			PEAR.EmpleadoId		= 656654

	JOIN app620.CatPerfilEmpleados PER
		ON 
			PER.Perfil_Ident	= PEAR.Perfil_Ident
		AND 
			PER.TipoAccesoId	= 3 

	--JOIN app620.CatPerfilEmpleados PES
	--	ON
	--		(PES.Country_Ident			= PER.Country_Ident			OR PER.Country_Ident		= - 1) 
	--	AND (PES.Location_Ident			= PER.Location_Ident		OR PER.Location_Ident		= - 1) 
	--	AND (PES.Client_Ident			= PER.Client_Ident			OR PER.Client_Ident			= - 1) 
	--	AND (PES.Program_Ident			= PER.Program_Ident			OR PER.Program_Ident		= - 1) 
	--	AND (PES.Contract_Type_Ident	= PER.Contract_Type_Ident	OR PER.Contract_Type_Ident	= - 1)
	--	AND PES.TipoAccesoId			= 1 

	--JOIN app620.CatEmployeeCCMSVw EMPSolicita
	--	ON 
	--		(EMPSolicita.Country_Ident			= PES.Country_Ident			OR PES.Country_Ident		= - 1) 
	--	AND (EMPSolicita.Location_Ident			= PES.Location_Ident		OR PES.Location_Ident		= - 1) 
	--	AND (EMPSolicita.Client_Ident			= PES.Client_Ident			OR PES.Client_Ident			= - 1) 
	--	AND (EMPSolicita.Program_Ident			= PES.Program_Ident			OR PES.Program_Ident		= - 1) 
	--	AND (EMPSolicita.Contract_Type_Ident	= PES.Contract_Type_Ident	OR PES.Contract_Type_Ident	= - 1) 
	--	AND PES.TipoAccesoId			= 1 

	--JOIN app620.CatPerfilEmpleadosAccesos PEAS
	--	ON
	--		PEAS.Perfil_Ident			= PES.Perfil_Ident
	--	-AND
			


		--AND PES.Perfil_Ident			= Sol.Perfil_Ident
END
