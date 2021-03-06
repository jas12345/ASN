USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatMesesNominaSel]    Script Date: 13/03/2019 05:26:30 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatMesesNominaSel]
AS
BEGIN
	SELECT
		 CONVERT(VARCHAR(4),mn.[AnioId])+CONVERT(VARCHAR(2),mn.[MesId]) AnioMesId
		,mn.[AnioId]
		,CONVERT(VARCHAR(10),  an.[FechaInicio], 120) FechaInicioAnio
		,CONVERT(VARCHAR(10),  an.[FechaCierre], 120) FechaCierreAnio
		,mn.[MesId]
		,mm.Descripcion
		,mn.[FechaInicio]
		,mn.[FechaCierre]
		,mn.Active
	FROM [app620].[CatMesesNomina] mn
	JOIN [app620].[CatAniosNomina] an
	ON an.AnioId = mn.AnioId
	JOIN app620.CatMeses mm
	ON mm.MesId = mn.MesId
END
