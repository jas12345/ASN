/****** Object:  StoredProcedure [app620].[ReporteAuditoriasDetalleSel]    Script Date: 02/09/2019 07:40:59 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [app620].[ReporteAuditoriasDetalleSel]
@FolioId INT = 0
AS
BEGIN
	--DECLARE @FolioId INT = 88

	SELECT
	b.FolioSolicitud, 
	b.Empleado_Ident, 
	b.ConceptoId, 
	g.Descripcion AS ConceptoDesc,
	b.ConceptoMotivoId, 
	f.Descripcion AS ConceptoMotivoDesc,
	b.ResponsableId, 
	e.Nombre As NombreResponsable,
	b.PeriodoOriginalId,
	c.ParametroConceptoMonto, 
	c.MotivosSolicitudId, 
	h.Descripcion AS MotivoSolicitudDesc,
	c.EstatusSolicitudId,
	d.Nombre As NombreEmpleado,
	convert(date,c.LastModifiedDate) AS FechaDeModificacion,
	convert(date,c.CreatedDate) AS FechaDeCreacion
	FROM app620.CatSolicitudes a
	INNER JOIN [app620].[CatSolicitudEmpleadosDetalle] b ON b.FolioSolicitud = a.FolioSolicitud
	INNER JOIN [app620].[CatEmpleadosSolicitudes] c ON c.FolioSolicitud = b.FolioSolicitud and c.Empleado_Ident = b.Empleado_Ident AND c.ConceptoId = b.ConceptoId
	LEFT JOIN [app620].[CatEmployeeCCMSVw] d ON b.Empleado_Ident = d.Ident
	LEFT JOIN [app620].[CatEmployeeCCMSVw] e ON b.ResponsableId = e.Ident
	INNER JOIN [app620].[CatConceptosMotivos] f ON b.ConceptoMotivoId = f.ConceptoMotivoId
	INNER JOIN [app620].[CatConceptos] g ON b.ConceptoId = g.ConceptoId
	INNER JOIN [app620].[CatMotivosSolicitud] h ON c.MotivosSolicitudId = h.MotivosSolicitudId
	WHERE a.PeriodoNominaId IS NOT NULL
	AND a.FolioSolicitud = @FolioId
	ORDER BY b.LastModifiedDate DESC
END