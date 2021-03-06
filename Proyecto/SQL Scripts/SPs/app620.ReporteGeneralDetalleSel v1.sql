USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[ReporteGeneralDetalleSel]    Script Date: 09/09/2019 03:40:19 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[ReporteGeneralDetalleSel]
@FolioId INT = 0
AS
BEGIN
	--DECLARE @FolioId INT = 88

	SELECT
	b.FolioSolicitud,
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
	b.ConceptoId, 
	g.Descripcion AS ConceptoDesc,
	c.MotivosSolicitudId, 
	h.Descripcion AS MotivoSolicitudDesc,
	b.ConceptoMotivoId, 
	f.Descripcion AS ConceptoMotivoDesc,
	b.ResponsableId, 
	e.Nombre As NombreResponsable,
	CASE WHEN y.ParametroConceptoId = 3 THEN CONVERT(VARCHAR(22), c.ParametroConceptoMonto) + ' ' + TM.TipoDeMoneda
		ELSE CONVERT(VARCHAR(22), c.ParametroConceptoMonto) + ' ' + y.Descripcion 
	END AS Monto,
	--b.PeriodoOriginalId,
	--c.ParametroConceptoMonto, 
	c.EstatusSolicitudId
	--d.Nombre As NombreEmpleado,
	--convert(date,c.LastModifiedDate) AS FechaDeModificacion,
	--convert(date,c.CreatedDate) AS FechaDeCreacion
	FROM app620.CatSolicitudes a
	INNER JOIN [app620].[CatSolicitudEmpleadosDetalle] b ON b.FolioSolicitud = a.FolioSolicitud
	INNER JOIN [app620].[CatEmpleadosSolicitudes] c ON c.FolioSolicitud = b.FolioSolicitud and c.Empleado_Ident = b.Empleado_Ident AND c.ConceptoId = b.ConceptoId
	LEFT JOIN [app620].[CatEmployeeCCMSVw] d ON b.Empleado_Ident = d.Ident
	LEFT JOIN [app620].[CatEmployeeCCMSVw] e ON b.ResponsableId = e.Ident
	INNER JOIN [app620].[CatConceptosMotivos] f ON b.ConceptoMotivoId = f.ConceptoMotivoId
	INNER JOIN [app620].[CatConceptos] g ON b.ConceptoId = g.ConceptoId
	INNER JOIN [app620].[CatMotivosSolicitud] h ON c.MotivosSolicitudId = h.MotivosSolicitudId
	LEFT JOIN [app620].[CatEmployeeCCMSVw] i ON d.Manager_Ident = i.Ident
	INNER JOIN [app620].[CatParametroConceptos] y ON g.ParametroConceptoId = y.ParametroConceptoId
	INNER JOIN [app620].[CatTipoDeMoneda] TM ON TM.Pais = d.country_ident
	WHERE a.PeriodoNominaId IS NOT NULL
	AND a.FolioSolicitud = @FolioId
	ORDER BY b.LastModifiedDate DESC
END