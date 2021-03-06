USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosSel]    Script Date: 12/06/2019 09:49:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatConceptosParametroConceptosSel]
	 @ConceptoId INT

AS
BEGIN
	SELECT
		 Con.ConceptoId
		,Con.Descripcion DescripcionConcepto
		,Con.TipoConceptoId
		--, *
		,PC.Descripcion DescripcionParametroConcepto
	FROM [app620].[CatConceptos] Con
	JOIN [app620].[CatParametroConceptos] PC
	ON PC.ParametroConceptoId = Con.ParametroConceptoId
	WHERE Con.ConceptoId = @ConceptoId
END
