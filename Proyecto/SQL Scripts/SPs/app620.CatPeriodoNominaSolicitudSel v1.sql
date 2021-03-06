USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[CatPeriodoNominaSolicitudSel]    Script Date: 13/01/2020 10:59:26 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatPeriodoNominaSolicitudSel]
	@FolioSolicitud INT = 0
AS
BEGIN
	SELECT
		 PN.PeriodoNominaId 
		,PN.NombrePeriodo
	FROM [app620].[CatPeriodosNomina] PN
	JOIN [app620].[CatSolicitudes] Sol
		ON Sol.PeriodoNominaId = PN.PeriodoNominaId
		AND Sol.FolioSolicitud = @FolioSolicitud
END
