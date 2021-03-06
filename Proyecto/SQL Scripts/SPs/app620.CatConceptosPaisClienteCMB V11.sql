USE [ASN_PE_Dev]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosPaisClienteCMB]    Script Date: 01/07/2020 01:27:06 p. m. ******/
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

	SET @PaisId = ISNULL(NULLIF(@PaisId,0),-1)
	SET @Perfil = ISNULL(NULLIF(@Perfil,0),-1)
	--SET @ClienteId = NULLIF(NULLIF(@ClienteId,0),-1)

	--------IF @Perfil = 0 
		BEGIN
			SELECT -1 AS Ident, '- Todos -' AS Valor
			UNION ALL
			SELECT DISTINCT
				 CC.[ConceptoId] As Ident
				,CC.[Descripcion] As Valor
			FROM [app620].[CatConceptos] CC
			JOIN [app620].[RelPerfilEmpleadosConceptos] PEC ON
				PEC.ConceptoId = CC.ConceptoId
				AND (PEC.Perfil_Ident = @Perfil OR @Perfil = -1)
				AND (CC.PaisId = @PaisId OR @PaisId = -1)
				AND CC.Active = 1
			JOIN [app620].[RelPerfilEmpleadosClientes] PECli ON
				PECli.Perfil_Ident = PEC.Perfil_Ident
				AND (PECli.Client_Ident	IN
						(
							SELECT	item Client_Ident 
							FROM	fnSplit(@ClienteId, ',')
						) 
					OR 
						@ClienteId = '-1'
				)
				
			ORDER BY Valor
		END
	--------ELSE
	--------	BEGIN

	--------		SELECT -1 AS Ident, '- Todos -' AS Valor
	--------		UNION ALL
	--------		SELECT DISTINCT
	--------			 CC.[ConceptoId] As Ident
	--------			,CC.[Descripcion] As Valor
	--------		FROM [app620].[CatConceptos] CC
	--------		LEFT JOIN [app620].[CatPerfilEmpleados] CP ON CP.[ConceptoId] = CC.ConceptoId
	--------		WHERE CC.Active = 1 AND  (@Perfil IS NULL OR CP.Perfil_Ident = @Perfil)
	--------			AND @PaisId IN (SELECT item FROM fnSplit(CC.PaisId, ','))
	--------			--AND ClienteId IN (ISNULL(@ClienteId,ClienteId), -1)
	--------			AND (ClienteId	IN
	--------					(
	--------						SELECT	item Client_Ident 
	--------						FROM	fnSplit(@ClienteId, ',')
	--------					) 
	--------						OR 
	--------							@ClienteId = '-1'
	--------					)

	--------		ORDER BY Valor
	--------	END
END