USE [ASN_PE]
GO
/****** Object:  StoredProcedure [app620].[CatMontosResponsabilidadesSel]    Script Date: 17/08/2020 06:35:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER exec [app620].[CatMontosResponsabilidadesSel]
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

	SELECT DISTINCT
		 COUNT(Con.Descripcion)[Cantidad]
		,Con.Descripcion ConceptoDesc
		--,CONVERT(VARCHAR(22), EmpSol.ParametroConceptoMonto) + ' ' +  Par.Descripcion Monto
		,CASE WHEN Par.ParametroConceptoId = 3 THEN CONVERT(VARCHAR(22), sum(EmpSol.ParametroConceptoMonto)) + ' ' + TM.TipoDeMoneda
			   ELSE CONVERT(VARCHAR(22), sum(EmpSol.ParametroConceptoMonto)) + ' ' + Par.Descripcion 
		  END AS Monto
	FROM
		app620.CatSolicitudes Sol

	JOIN [app620].[CatEmpleadosSolicitudes] EmpSol 
		ON EmpSol.FolioSolicitud = Sol.FolioSolicitud
	    AND Sol.FolioSolicitud = @FolioSolicitud
	    --AND Sol.FolioSolicitud = 9
		AND Sol.Active = 1
		AND EmpSol.Active = 1

	JOIN app620.CatEstatusSolicitudes ES
		ON ES.EstatusSolicitudId = EmpSol.EstatusSolicitudId

	JOIN app620.CatEmployeeCCMSVw EMP 
		--ON EMP.Ident = Sol.Solicitante_Ident
		ON EMP.Ident = EmpSol.Empleado_Ident

	JOIN app620.CatConceptos Con
		ON Con.ConceptoId = EmpSol.ConceptoId

	JOIN  app620.CatParametroConceptos Par
		ON Par.[ParametroConceptoId] = Con.ParametroConceptoId   and
		par.parametroConceptoid = 3 -- filtra solo los montos

    LEFT JOIN app620.CatMotivosSolicitud CMS 
		ON CMS.MotivosSolicitudId = EmpSol.MotivosSolicitudId

	LEFT JOIN app620.CatSolicitudEmpleadosDetalle SED
		ON SED.FolioSolicitud		= Empsol.FolioSolicitud
		AND SED.[Empleado_Ident]	= Empsol.[Empleado_Ident]
		AND SED.[ConceptoId]		= Empsol.[ConceptoId]
		AND SED.Active = 1

	LEFT JOIN app620.CatEmployeeCCMSVw EMP2 
		ON EMP2.Ident = SED.ResponsableId
		
	LEFT JOIN app620.CatConceptosMotivos ConMot
		ON ConMot.ConceptoMotivoId = SED.ConceptoMotivoId

	JOIN app620.CatPerfilEmpleadosAccesos PEAR
		ON
				PEAR.EmpleadoId		= @Responsable_Ident
			AND	
				PEAR.Active = 1
			--PEAR.EmpleadoId		= 656654

	JOIN app620.CatPerfilEmpleados PER
		ON 
			PER.Perfil_Ident	= PEAR.Perfil_Ident
		AND 
			PER.TipoAccesoId	= 3 
		AND 
			PER.Active			= 1

		AND	(EMP.Country_Ident			= PER.Country_Ident			OR PER.Country_Ident = -1)
		AND	(EMP.Location_Ident			= PER.Location_Ident		OR PER.Location_Ident = -1)
		--AND	(EMP.Client_Ident			= PER.Client_Ident			OR PER.Client_Ident = -1)
		AND	(EMP.Program_Ident			= PER.Program_Ident			OR PER.Program_Ident = -1)
		AND (EMP.Contract_Type_Ident	= PER.Contract_Type_Ident	OR PER.Contract_Type_Ident = -1)

		--AND (Emp.Ident					= EMS.Empleado_Ident)

		JOIN [app620].[CatRelLocationBiosCCMSVw] BiosCity ON 
				(BiosCity.location_bios		= PER.City_Ident				OR PER.City_Ident = -1)
			AND (BiosCity.location_ccms		= EMP.Location_Ident)

	JOIN [app620].[CatTipoDeMoneda] TM ON TM.Pais = EMP.country_ident 

	GROUP BY Con.Descripcion, TM.TipoDeMoneda,Par.Descripcion, Par.ParametroConceptoId 
		ORDER BY Monto

END

