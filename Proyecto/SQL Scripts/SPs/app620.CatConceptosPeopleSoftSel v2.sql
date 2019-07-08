USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosPeopleSoftSel]    Script Date: 08/07/2019 12:27:57 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatConceptosPeopleSoftSel]
AS
BEGIN
	SELECT
		 [ConceptoId]
		,[Descripcion]
		,[DescripcionPeopleSoft]
		,Active
	FROM [app620].[CatConceptosPeopleSoft]
END
