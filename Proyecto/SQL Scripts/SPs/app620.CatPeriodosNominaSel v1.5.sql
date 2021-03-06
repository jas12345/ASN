USE [ASN7]
GO
/****** Object:  StoredProcedure [app620].[CatPeriodosNominaSel]    Script Date: 30/03/2020 06:26:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatPeriodosNominaSel]
AS
BEGIN
	SELECT
		 PN.[AnioId]
		,PN.[MesId]
		,PN.[PeriodicidadNominaId]
		,PN.[ConsecutivoId]
		,PN.[TipoPeriodo]
		,CP.TipoConsecutivoId
		,TC.Descripcion
		,CONVERT(date, PN.FechaInicio) FechaInicio
		,CONVERT(date, PN.[FechaFin]) FechaFin, CONVERT(date, GETDATE()) Actual
		,PN.[FechaCaptura]
		,PN.[FechaCierre]
		,PN.[CountryIdents]
		,PN.[NombrePeriodo]
		,PN.[Active]
		,(CASE 
			WHEN (CONVERT(date, PN.FechaInicio) <= CONVERT(date, GETDATE()) AND CONVERT(date, PN.FechaFin) >= CONVERT(date, GETDATE())) THEN 'En Curso' 
			WHEN (CONVERT(date, PN.FechaFin) < CONVERT(date, GETDATE())) THEN 'Cerrado'
			WHEN (CONVERT(date, PN.FechaInicio) > CONVERT(date, GETDATE())) THEN 'Futuro'  
			END) AS Estatus
	FROM [app620].[CatPeriodosNomina] PN
	JOIN [app620].[CatConsecutivoPeriodos] CP
		ON CP.AnioId					= PN.AnioId
		AND CP.MesId					= PN.MesId
		AND CP.PeriodicidadNominaId		= PN.PeriodicidadNominaId
		AND CP.ConsecutivoId			= PN.ConsecutivoId
	JOIN [app620].[CatTiposConsecutivo] TC
		ON TC.TipoConsecutivoId = CP.TipoConsecutivoId
END