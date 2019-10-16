ALTER PROC [app620].[CatPerfilEmpleadosSel]
	@Perfil_Ident INT = 0 
AS
BEGIN

	SET @Perfil_Ident = ISNULL(@Perfil_Ident, 0)

	SELECT
		 Perfil.[Perfil_Ident]
		,[NombrePerfilEmpleados]
		,Perfil.[Country_Ident]
		,Pais.Country_Full_Name
		,ISNULL(CCVW.Id, -1) City_Ident
		,CCVW.Value City_Name
		,Perfil.[Location_Ident]
		,Location.full_name Location_Name
		,Perfil.[Client_Ident]
		,Client.Client_Name
		,Perfil.[Program_Ident]
		,Program.Program_Name
		,Perfil.[Contract_Type_Ident]
		,Contract.Contract_Type
		--,Perfil.ConceptoId
		,Concepto.Descripcion Concepto
		,Perfil.TipoAccesoId
		,TipoAcceso.Descripcion TipoAcceso
		,Perfil.Active
		,CASE
				WHEN COUNT(CC.Descripcion) > 1
				THEN 'VARIOS'
				ELSE (	SELECT	Descripcion
						FROM	[app620].[RelPerfilEmpleadosConceptos] A WITH(NOLOCK)
								JOIN app620.CatConceptos B ON A.ConceptoId = B.ConceptoId
						WHERE	A.Perfil_Ident = Perfil.Perfil_Ident)
		END AS ConceptoNombre
		,(SELECT DISTINCT  
    SUBSTRING(
        (
            SELECT ',' + CONVERT(VARCHAR(1500),REC1.ConceptoId)  AS [text()]
            FROM app620.RelPerfilEmpleadosConceptos REC1
				JOIN app620.CatConceptos B ON REC1.ConceptoId = B.ConceptoId
            WHERE REC1.Perfil_Ident = REC2.Perfil_Ident
            ORDER BY REC1.Perfil_Ident
            FOR XML PATH ('')
        ), 2, 1000) [ConceptoId]
FROM app620.RelPerfilEmpleadosConceptos REC2 WHERE REC2.Perfil_Ident = Perfil.Perfil_Ident)
		 AS ConceptoId
	FROM [app620].[CatPerfilEmpleados] Perfil
	JOIN [app620].[RelPerfilEmpleadosConceptos] REC WITH(NOLOCK) ON REC.Perfil_Ident = Perfil.Perfil_Ident
	LEFT JOIN [app620].[CatCountryVw] Pais ON Pais.[Country_Ident] = Perfil.Country_Ident
	LEFT JOIN [app620].[CatLocationVw] Location ON Location.Location_Ident = Perfil.Location_Ident
	LEFT JOIN [app620].[CatClientVw] Client ON client.Client_Ident = Perfil.Client_Ident
	LEFT JOIN [app620].[CatProgramVw] Program ON Program.Program_Ident = perfil.Program_Ident
	LEFT JOIN [app620].[CatContractTypeVw] Contract ON Contract.Contract_Type_Ident = Perfil.Contract_Type_Ident
	LEFT JOIN [app620].[CatConceptos] Concepto ON Concepto.ConceptoId = Perfil.ConceptoId
	LEFT JOIN [app620].[CatTiposAcceso] TipoAcceso ON TipoAcceso.TipoAccesoId = Perfil.[TipoAccesoId]
	LEFT JOIN [app620].[CatConceptos] CC ON CC.ConceptoId = REC.ConceptoId
	LEFT JOIN [app620].[CatCityVw] CCVW ON CCVW.Id = Perfil.City_Ident
	WHERE (Perfil.Perfil_Ident =@Perfil_Ident OR @Perfil_Ident = 0)
	GROUP BY Perfil.[Perfil_Ident]
			,[NombrePerfilEmpleados]
			,Perfil.[Country_Ident]
			,Pais.Country_Full_Name
			,ISNULL(CCVW.Id, -1)
			,CCVW.Value 
			,Perfil.[Location_Ident]
			,Location.full_name 
			,Perfil.[Client_Ident]
			,Client.Client_Name
			,Perfil.[Program_Ident]
			,Program.Program_Name
			,Perfil.[Contract_Type_Ident]
			,Contract.Contract_Type
			,Perfil.ConceptoId
			,Concepto.Descripcion
			,Perfil.TipoAccesoId
			,TipoAcceso.Descripcion
			,Perfil.Active
	ORDER BY Perfil.Perfil_ident
END


