USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[AutorizadorxConceptoxNivelCMB]    Script Date: 25/07/2019 05:54:25 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[AutorizadorxConceptoxNivelCMB]
(
	  @ConceptoId INT	= 0
	 ,@NivelId INT		= 0
)
AS

BEGIN
	SET @ConceptoId = ISNULL(@ConceptoId, 0)
	SET @NivelId = ISNULL(@NivelId, 0)

	SELECT
		 ISNULL(AutorizadorIdent , 0)
		,AutorizacionObligatoria
	FROM
		CatConceptosNivelAutorizador
	WHERE 
		ConceptoId	= @ConceptoId
	AND 
		NivelId		= @NivelId
END
