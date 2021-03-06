USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosParametroConceptosSel]    Script Date: 23/08/2019 05:23:10 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatConceptosParametroConceptosSel]
	 @ConceptoId INT
	 ,@EmployeeId INT 
AS
BEGIN
	DECLARE @Pais INT = (SELECT country_ident FROM [app620].[CatEmployeeCCMSVw] WHERE Ident = @EmployeeId)

	SELECT
		 Con.ConceptoId
		,Con.Descripcion DescripcionConcepto
		,Con.TipoConceptoId
		--,PC.Descripcion DescripcionParametroConcepto
		, CASE WHEN PC.ParametroConceptoId = 3 THEN TM.TipoDeMoneda
			   ELSE PC.Descripcion 
		  END AS DescripcionParametroConcepto
		,Con.NumeroNivelAutorizante NivelesAutorizacion
	FROM [app620].[CatConceptos] Con
	JOIN [app620].[CatParametroConceptos] PC
	ON PC.ParametroConceptoId = Con.ParametroConceptoId
	JOIN [app620].[CatTipoDeMoneda] TM ON TM.Pais = @Pais
	WHERE Con.ConceptoId = @ConceptoId
END
