USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosPeopleSoftSel]    Script Date: 05/07/2019 11:41:36 a. m. ******/
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
		,Active
	FROM [app620].[CatConceptosPeopleSoft]
END
