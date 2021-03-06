USE [ASN7]
GO
/****** Object:  StoredProcedure [app620].[CatPeriodosNominaSel]    Script Date: 31/03/2020 12:22:18 p. m. ******/
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
		,PN.FechaInicio FechaInicio
		,PN.FechaFin FechaFin
		,GETDATE() Actual
		,PN.[FechaCaptura]
		,PN.[FechaCierre]
		,PN.[CountryIdents]
		,PN.[NombrePeriodo]
		,PN.[Active]
		,(CASE 
			WHEN (PN.FechaInicio <= GETDATE()) AND (PN.FechaCaptura >=  GETDATE()) THEN 'En Curso' 
			WHEN (PN.FechaCaptura < GETDATE()) THEN 'Cerrado'
			WHEN (PN.FechaInicio > GETDATE()) THEN 'Futuro'  
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