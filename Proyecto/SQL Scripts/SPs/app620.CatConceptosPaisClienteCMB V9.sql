USE [ASN_PE_Dev]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosPaisClienteCMB]    Script Date: 30/06/2020 09:35:30 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[CatConceptosPaisClienteCMB]
	 @Perfil INT = 0
	,@PaisId INT = NULL
	,@ClienteId VARCHAR(2000) = ''
AS
BEGIN

	SET @PaisId = NULLIF(NULLIF(@PaisId,0),-1)
	--SET @ClienteId = NULLIF(NULLIF(@ClienteId,0),-1)

	IF @Perfil = 0 
		BEGIN
			SELECT -1 AS Ident, '- Todos -' AS Valor
			UNION ALL
			SELECT DISTINCT
				 [ConceptoId] As Ident
				,[Descripcion] As Valor
			FROM [app620].[CatConceptos]
			WHERE Active = 1 
				AND (@PaisId IN (SELECT item FROM fnSplit([app620].[CatConceptos].PaisId, ',')) OR @PaisId IS NULL)
				--AND (ClienteId IN (ISNULL(@ClienteId,ClienteId), -1) OR @ClienteId IS NULL)
				AND (ClienteId	IN
						(
							SELECT	item Client_Ident 
							FROM	fnSplit(@ClienteId, ',')
						) 
							OR 
								@ClienteId = '-1'
						)

			ORDER BY Valor
		END
	ELSE
		BEGIN

			SELECT -1 AS Ident, '- Todos -' AS Valor
			UNION ALL
			SELECT DISTINCT
				 CC.[ConceptoId] As Ident
				,CC.[Descripcion] As Valor
			FROM [app620].[CatConceptos] CC
			LEFT JOIN [app620].[CatPerfilEmpleados] CP ON CP.[ConceptoId] = CC.ConceptoId
			WHERE CC.Active = 1 AND  (@Perfil IS NULL OR CP.Perfil_Ident = @Perfil)
				AND @PaisId IN (SELECT item FROM fnSplit(CC.PaisId, ','))
				--AND ClienteId IN (ISNULL(@ClienteId,ClienteId), -1)
				AND (ClienteId	IN
						(
							SELECT	item Client_Ident 
							FROM	fnSplit(@ClienteId, ',')
						) 
							OR 
								@ClienteId = '-1'
						)

			ORDER BY Valor
		END
END