USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[ReporteIndividualDetalleSel]    Script Date: 27/02/2020 11:16:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[ReporteIndividualDetalleSel]
@FolioId INT = 0
AS
BEGIN
	--DECLARE @FolioId INT = 88

	SELECT
	a.FolioSolicitud,
	d.country_full_name,
	d.country_ident,
	d.Location_Name,
	d.Location_Ident,
	d.Client_Name,
	d.Client_Ident,
	d.[Program_Name],
	d.Program_Ident,
	i.Ident AS JefeInmediatoCCMSID,
	i.Nombre AS JefeInmediatoNombre,
	d.Ident AS EmpleadoCCMSID,
	d.Nombre AS EmpleadoNombre,
	c.ConceptoId, 
	g.Descripcion AS ConceptoDesc,
	c.MotivosSolicitudId, 
	h.Descripcion AS MotivoSolicitudDesc,
	b.ConceptoMotivoId,
	--CASE b.ConceptoMotivoId 
	--	WHEN -1 THEN NULL
	--	ELSE b.ConceptoMotivoId
	--END ConceptoMotivoId, 

	f.Descripcion AS ConceptoMotivoDesc,
	b.ResponsableId, 
	e.Nombre As NombreResponsable,
	--CASE WHEN y.ParametroConceptoId = 3 THEN CONVERT(VARCHAR(22), c.ParametroConceptoMonto) + ' ' + TM.TipoDeMoneda
	--	ELSE CONVERT(VARCHAR(22), c.ParametroConceptoMonto) + ' ' + y.Descripcion 
	--END AS Monto,
	c.ParametroConceptoMonto AS Monto,
	--CONVERT(VARCHAR(22), c.ParametroConceptoMonto) AS Monto,
	CASE WHEN y.ParametroConceptoId = 3 THEN TM.TipoDeMoneda
		ELSE y.Descripcion 
	END AS ParametroConcepto,
	--y.Descripcion ParametroConcepto
	--b.PeriodoOriginalId,
	--c.ParametroConceptoMonto, 
	c.EstatusSolicitudId
	,ES.Descripcion EstatusSolicitud
	--d.Nombre As NombreEmpleado,
	--convert(date,c.LastModifiedDate) AS FechaDeModificacion,
	--convert(date,c.CreatedDate) AS FechaDeCreacion
	FROM app620.CatSolicitudes a
	LEFT JOIN [app620].[CatEmpleadosSolicitudes] c ON c.FolioSolicitud = a.FolioSolicitud --and c.Empleado_Ident = b.Empleado_Ident AND c.ConceptoId = b.ConceptoId
	LEFT JOIN [app620].[CatSolicitudEmpleadosDetalle] b ON b.FolioSolicitud = c.FolioSolicitud and c.Empleado_Ident = b.Empleado_Ident AND c.ConceptoId = b.ConceptoId
	LEFT JOIN [app620].[CatEmployeeCCMSVw] d ON d.Ident = c.Empleado_Ident
	LEFT JOIN [app620].[CatEmployeeCCMSVw] e ON e.Ident = b.ResponsableId
	LEFT JOIN [app620].[CatConceptosMotivos] f ON f.ConceptoMotivoId = b.ConceptoMotivoId
	LEFT JOIN [app620].[CatConceptos] g ON c.ConceptoId = g.ConceptoId
	LEFT JOIN [app620].[CatMotivosSolicitud] h ON c.MotivosSolicitudId = h.MotivosSolicitudId
	LEFT JOIN [app620].[CatEmployeeCCMSVw] i ON d.Manager_Ident = i.Ident
	LEFT JOIN [app620].[CatParametroConceptos] y ON g.ParametroConceptoId = y.ParametroConceptoId
	LEFT JOIN [app620].[CatTipoDeMoneda] TM ON TM.Pais = d.country_ident
	LEFT JOIN app620.CatEstatusSolicitudes ES ON es.EstatusSolicitudId = c.EstatusSolicitudId
	WHERE a.PeriodoNominaId IS NOT NULL
	AND a.FolioSolicitud = @FolioId
	ORDER BY c.LastModifiedDate DESC
END