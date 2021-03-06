USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatResponsabilidadesSel]    Script Date: 23/08/2019 05:33:35 p. m. ******/
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

	SELECT DISTINCT
		 Sol.[FolioSolicitud]
		,Sol.Solicitante_Ident
		,EMP.Ident
		,EMP.Nombre
		,Con.ConceptoId
		,Con.Descripcion ConceptoDesc
		--,CONVERT(VARCHAR(22), EmpSol.ParametroConceptoMonto) + ' ' +  Par.Descripcion Monto
		,CASE WHEN Par.ParametroConceptoId = 3 THEN CONVERT(VARCHAR(22), EmpSol.ParametroConceptoMonto) + ' ' + TM.TipoDeMoneda
			   ELSE CONVERT(VARCHAR(22), EmpSol.ParametroConceptoMonto) + ' ' + Par.Descripcion 
		  END AS Monto
		,CMS.MotivosSolicitudId
		,CMS.Descripcion MotivosSolicitudDesc
		,ISNULL(ConMot.ConceptoMotivoId, -1) ConceptoMotivoId
		,ConMot.Descripcion ConceptoMotivoDesc
		,ISNULL(SED.ResponsableId, 0) ResponsableId
		,EMP2.Nombre NombreResponsable
		,ISNULL(SED.PeriodoOriginalId, -1) PeriodoOriginalId
		,ES.EstatusSolicitudId EstatusId
		,ES.Descripcion EstatusSolicitud
		--,SEA.NivelAutorizacion
		,EmpSol.Active

	FROM
		app620.CatSolicitudes Sol

	JOIN [ASN2].[app620].[CatEmpleadosSolicitudes] EmpSol 
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

	JOIN app620.CatParametroConceptos Par
		ON Par.[ParametroConceptoId] = Con.ParametroConceptoId

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
			--PEAR.EmpleadoId		= 656654

	JOIN app620.CatPerfilEmpleados PER
		ON 
			PER.Perfil_Ident	= PEAR.Perfil_Ident
		AND 
			PER.TipoAccesoId	= 3 
	JOIN [app620].[CatTipoDeMoneda] TM ON TM.Pais = EMP.country_ident

END
