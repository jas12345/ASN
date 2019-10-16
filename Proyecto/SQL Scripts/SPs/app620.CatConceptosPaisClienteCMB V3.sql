USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosPaisClienteCMB]    Script Date: 15/10/2019 07:10:48 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[CatConceptosPaisClienteCMB]
@Perfil INT = 0
,@PaisId INT = NULL
,@ClienteId INT = NULL
AS
BEGIN

	SET @PaisId = NULLIF(NULLIF(@PaisId,0),-1)
	SET @ClienteId = NULLIF(NULLIF(@ClienteId,0),-1)

	IF @Perfil = 0 
	BEGIN
		SELECT DISTINCT
			 [ConceptoId] As Ident
			,[Descripcion] As Valor
		FROM [app620].[CatConceptos]
		WHERE Active = 1 
			--AND PaisId = ISNULL(@PaisId,PaisId)
			AND @PaisId IN (SELECT item FROM fnSplit([app620].[CatConceptos].PaisId, ','))
			AND ClienteId IN (ISNULL(@ClienteId,ClienteId), -1)
	END
	ELSE
	BEGIN

		SELECT DISTINCT
			 CC.[ConceptoId] As Ident
			,CC.[Descripcion] As Valor
		FROM [app620].[CatConceptos] CC
		LEFT JOIN [app620].[CatPerfilEmpleados] CP ON CP.[ConceptoId] = CC.ConceptoId
		WHERE CC.Active = 1 AND  (@Perfil IS NULL OR CP.Perfil_Ident = @Perfil)
			--AND PaisId = ISNULL(@PaisId,PaisId)
			AND @PaisId IN (SELECT item FROM fnSplit(CC.PaisId, ','))
			AND ClienteId IN (ISNULL(@ClienteId,ClienteId), -1)
	END
END
