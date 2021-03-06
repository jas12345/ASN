USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatMontosAutorizacionesSel]    Script Date: 01/09/2020 01:16:34 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[CatMontosAutorizacionesSel]
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

	DECLARE @TempAutorizantes AS TABLE (FolioSolicitud INT,Empleado_Ident INT, ConceptoId INT, Autorizador_Ident INT,Pendiente BIT, Autorizado BIT, Rechazado BIT, Cancelado BIT)

	INSERT	INTO @TempAutorizantes(FolioSolicitud,Empleado_Ident,ConceptoId,Autorizador_Ident,Pendiente,Autorizado,Rechazado,Cancelado)
	SELECT	FolioSolicitud,Empleado_Ident,ConceptoId,Autorizador_Ident,Pendiente,Autorizado,Rechazado,Cancelado
	FROM	[app620].[CatSolicitudEmpleadosAutorizantes]
	WHERE	FolioSolicitud = @FolioSolicitud
			AND Autorizador_Ident IS NOT NULL
			AND (Pendiente = 1 OR Rechazado = 1 OR Cancelado = 1)

	SELECT
		 count(Con.Descripcion)[Cantidad]
		,Con.Descripcion ConceptoDesc
			,CASE WHEN Par.ParametroConceptoId = 3 THEN Convert(varchar,CAST(sum(EmpSol.ParametroConceptoMonto)as money),1) + ' ' + TM.TipoDeMoneda
			   ELSE CAST(SUM( EmpSol.ParametroConceptoMonto)AS VARCHAR) + ' ' + Par.Descripcion 
		  END AS Monto

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

	JOIN app620.CatSolicitudEmpleadosAutorizantes SEA
		ON SEA.FolioSolicitud = Empsol.FolioSolicitud
		AND SEA.[Empleado_Ident] = Empsol.[Empleado_Ident]
		AND SEA.[ConceptoId] = Empsol.[ConceptoId]
		--AND SEA.Pendiente = 1
		AND SEA.Autorizador_Ident = @Autorizante_Ident

	LEFT JOIN app620.CatEmployeeCCMSVw EMP2 
		ON EMP2.Ident = SED.ResponsableId

	LEFT JOIN [app620].[CatConceptosMotivos] ConMot
		ON ConMot.ConceptoMotivoId = SED.ConceptoMotivoId

	LEFT JOIN @TempAutorizantes SEA2 
		ON	SEA2.FolioSolicitud = Sol.FolioSolicitud 
		AND SEA2.Empleado_Ident	= EmpSol.Empleado_Ident
			AND Con.ConceptoId = SEA2.ConceptoId

	LEFT JOIN [app620].[CatEmployeeCCMSVw] AUT 
		ON	AUT.Ident = SEA2.Autorizador_Ident

		JOIN [app620].[CatTipoDeMoneda] TM ON TM.Pais = EMP.country_ident
	WHERE Sol.[Active] = 1
	AND EmpSol.Active = 1
    AND Sol.FolioSolicitud = @FolioSolicitud


		GROUP BY Con.Descripcion, TM.TipoDeMoneda,Par.Descripcion, Par.ParametroConceptoId 
		ORDER BY Monto
END

