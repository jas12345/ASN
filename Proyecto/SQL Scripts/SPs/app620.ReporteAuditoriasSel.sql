/****** Object:  StoredProcedure [app620].[ReporteAuditoriasSel]    Script Date: 02/09/2019 07:39:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [app620].[ReporteAuditoriasSel]
AS
BEGIN
	SELECT
	a.PeriodoNominaId, a.FolioSolicitud, a.Fecha_Solicitud, Solicitante_Ident, EstatusSolicitudId, b.Nombre AS NombreDelSolicitante, a.LastModifiedDate AS FechaDeModificacion, YEAR(a.Fecha_Solicitud) As Anio
	FROM app620.CatSolicitudes a
	INNER JOIN [app620].[CatEmployeeCCMSVw] b on a.Solicitante_Ident = b.Ident
	WHERE a.PeriodoNominaId IS NOT NULL
	ORDER BY a.FolioSolicitud DESC
END