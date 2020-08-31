USE [ASN]
GO

/****** Object:  StoredProcedure [app620].[CatMontosSolicitudesSel]    Script Date: 31/08/2020 17:16:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROC [app620].[CatMontosSolicitudesSel]
	@FolioSolicitud INT = 0
AS
BEGIN

	SET @FolioSolicitud = ISNULL(@FolioSolicitud, 0)

	DECLARE @TempAutorizantes AS TABLE (FolioSolicitud INT,Empleado_Ident INT, ConceptoId INT, Autorizador_Ident INT,Pendiente BIT, Autorizado BIT, Rechazado BIT, Cancelado BIT)

	INSERT	INTO @TempAutorizantes(FolioSolicitud,Empleado_Ident,ConceptoId,Autorizador_Ident,Pendiente,Autorizado,Rechazado,Cancelado)
	SELECT	FolioSolicitud,Empleado_Ident,ConceptoId,Autorizador_Ident,Pendiente,Autorizado,Rechazado,Cancelado
	FROM	[app620].[CatSolicitudEmpleadosAutorizantes]
	WHERE	FolioSolicitud = @FolioSolicitud
			AND Autorizador_Ident IS NOT NULL
			AND (Pendiente = 1 OR Rechazado = 1 OR Cancelado = 1)

	SELECT count(Con.Descripcion) [Cantidad], 
	Con.Descripcion ConceptoDesc,
	CASE WHEN Par.ParametroConceptoId = 3 THEN cast(sum(EmpSol.ParametroConceptoMonto)as varchar) + ' ' + TM.TipoDeMoneda
	ELSE cast(sum(EmpSol.ParametroConceptoMonto)as varchar) + ' ' + Par.Descripcion  END 
	AS Monto

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
		ON Par.[ParametroConceptoId] = Con.ParametroConceptoId and
		Par.[ParametroConceptoId] = 3    -- filtro para montos

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
		AND SEA.Empleado_Ident	= EmpSol.Empleado_Ident
			AND Con.ConceptoId = SEA.ConceptoId

	LEFT JOIN [app620].[CatEmployeeCCMSVw] AUT 
		ON	AUT.Ident = SEA.Autorizador_Ident

		JOIN [app620].[CatTipoDeMoneda] TM ON TM.Pais = EMP.country_ident
	WHERE Sol.[Active] = 1
	AND EmpSol.Active = 1
    AND (Sol.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

	-- WHERE CS.[Active] = 1
	-- AND (CS.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

		--ORDER BY EmpSol.LastModifiedDate DESC
		GROUP BY Con.Descripcion, TM.TipoDeMoneda,Par.Descripcion, Par.ParametroConceptoId 
		ORDER BY Monto
END
GO

