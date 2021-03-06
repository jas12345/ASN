USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosPeopleSoftCMB]    Script Date: 28/06/2019 02:21:32 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatConceptosPeopleSoftCMB]
	@TipoConceptoId INT = 0
AS
BEGIN

	SET @TipoConceptoId = ISNULL(@TipoConceptoId, 0)

		SELECT DISTINCT
			 CC.[ConceptoId] As Ident
			,CC.[Descripcion] As Valor
		FROM [app620].[CatConceptosPeopleSoft] CC
		WHERE CC.Active = 1 AND  (@TipoConceptoId = 0 OR CC.TipoConceptoId = @TipoConceptoId)
END
