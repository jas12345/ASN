USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[AutorizadoresxConceptoCMB]    Script Date: 20/07/2019 04:39:47 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [app620].[CatConceptosNivelAutorizadorSi]
(
	  @ConceptoId INT	= 0
	 ,@NivelId INT		= 0
)
AS

BEGIN
	SET @ConceptoId = ISNULL(@ConceptoId, 0)
	SET @NivelId = ISNULL(@NivelId, 0)

	SELECT
		AutorizadorIdent 
	FROM
		CatConceptosNivelAutorizador
	WHERE 
		ConceptoId	= @ConceptoId
	AND 
		NivelId		= @NivelId
END
