USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[ReporteIndividualSel]    Script Date: 27/02/2020 10:42:19 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[ReporteIndividualSel]
@SolicitanteIdent INT = 0
AS
BEGIN
	SELECT
		  a.PeriodoNominaId
		, pn.NombrePeriodo
		, a.FolioSolicitud
		, a.Fecha_Solicitud
		, Solicitante_Ident
		, a.EstatusSolicitudId
		, b.Nombre AS NombreDelSolicitante
		, a.LastModifiedDate AS FechaDeModificacion
		, YEAR(a.Fecha_Solicitud) As Anio
	FROM 
		app620.CatSolicitudes a
	INNER JOIN [app620].[CatEmployeeCCMSVw] b on a.Solicitante_Ident = b.Ident
	INNER JOIN app620.CatPeriodosNomina PN ON PN.PeriodoNominaId = a.PeriodoNominaId
	WHERE 
		a.PeriodoNominaId IS NOT NULL
	AND 
		a.Solicitante_Ident = @SolicitanteIdent
	ORDER BY 
		a.FolioSolicitud DESC
END