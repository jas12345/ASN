USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosSel]    Script Date: 24/06/2019 01:20:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatConceptosSel]
AS
BEGIN
	SELECT
		 [ConceptoId]
		,[Descripcion]
		,[TipoConceptoId]
		,[PaisId]
		,CAST(PaisId as varchar) as Paises
		,[ClienteId]
		,app620.CatClientVw.Client_Name Cliente
		,[PeopleSoftId]
		,[NumeroNivelAutorizante]
		,[AutorizacionAutomatica]
		,[AutorizacionObligatoria]
		,[Vigencia]
		,[PagosFijos]
		,[Tope]
		,[PeriodicidadNominaId]
		,convert(nvarchar(10),FechaInicio,120) AS FechaInicio
		,convert(nvarchar(10),FechaFin,120) AS FechaFin
		,[ParametroConceptoId]
		,Active
	FROM [app620].[CatConceptos]
	LEFT JOIN [app620].[CatClientVw]
		ON app620.CatClientVw.Client_Ident = CatConceptos.ClienteId
END
