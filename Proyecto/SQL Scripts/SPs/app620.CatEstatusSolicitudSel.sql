USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatEstatusSolicitudSel]    Script Date: 18/07/2019 06:19:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].CatEstatusSolicitudSel
	@FolioSolicitud INT = 0
AS
BEGIN
	SELECT
		 ES.EstatusSolicitudId 
		,ES.Descripcion
	FROM [app620].[CatEstatusSolicitudes] ES
	JOIN [app620].[CatSolicitudes] Sol
		ON Sol.EstatusSolicitudId = ES.EstatusSolicitudId
		AND sol.FolioSolicitud = @FolioSolicitud
END
