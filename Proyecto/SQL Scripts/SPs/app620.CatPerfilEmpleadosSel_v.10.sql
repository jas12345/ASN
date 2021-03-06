USE [ASN_PE]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosSel]    Script Date: 18/05/2020 03:05:59 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[CatPerfilEmpleadosSel]
	@Perfil_Ident INT = 0 
AS
BEGIN

	SET @Perfil_Ident = ISNULL(@Perfil_Ident, 0)

	CREATE TABLE #TempPerfilEmpleadosClientes(
		 [Perfil_Ident]		INT
		,[Client_Ident]		VARCHAR(1500)
		,[Client_Name]		VARCHAR(50)
	)

	INSERT INTO #TempPerfilEmpleadosClientes
	SELECT
		 PE.Perfil_Ident
		,(
			SELECT DISTINCT  
			SUBSTRING(
				(
					SELECT ',' + CONVERT(VARCHAR(1500), RECli1.Client_Ident)  AS [text()]
					FROM app620.RelPerfilEmpleadosClientes RECli1
						JOIN app620.CatClientVw B ON RECli1.Client_Ident = B.Client_Ident
					WHERE RECli1.Perfil_Ident = RECli2.Perfil_Ident
					ORDER BY B.Client_Name
					FOR XML PATH ('')
				), 2, 1000) [Client_Ident]
			FROM app620.RelPerfilEmpleadosConceptos RECli2 WHERE RECli2.Perfil_Ident = PE.Perfil_Ident
		) AS ConceptoId
		,CASE
			WHEN COUNT(CC.Client_Name) > 1
			THEN 'VARIOS'
			ELSE (	SELECT	Client_Name
					FROM	[app620].[RelPerfilEmpleadosClientes] A WITH(NOLOCK)
							JOIN app620.CatClientVw B ON B.Client_Ident = A.Client_Ident
					WHERE	A.Perfil_Ident = PE.Perfil_Ident)
		 END AS Client_Name
	FROM app620.CatPerfilEmpleados PE
	JOIN app620.RelPerfilEmpleadosClientes RPECli ON RPECli.Perfil_Ident = PE.Perfil_Ident 
	LEFT JOIN [app620].[CatClientVw] CC ON CC.Client_Ident = RPECli.Client_Ident
	GROUP BY PE.Perfil_Ident

	CREATE TABLE #TempPerfilEmpleadosConceptos(
		 [Perfil_Ident]		INT
		,[ConceptoId]		VARCHAR(1500)
		,[Descripcion]		VARCHAR(50)
	)

	INSERT INTO #TempPerfilEmpleadosConceptos
	SELECT
		 PE.Perfil_Ident
		,(
			SELECT DISTINCT  
			SUBSTRING(
				(
					SELECT ',' + CONVERT(VARCHAR(1500),REC1.ConceptoId)  AS [text()]
					FROM app620.RelPerfilEmpleadosConceptos REC1
						JOIN app620.CatConceptos B ON REC1.ConceptoId = B.ConceptoId
					WHERE REC1.Perfil_Ident = REC2.Perfil_Ident
					ORDER BY B.Descripcion
					FOR XML PATH ('')
				), 2, 1000) [ConceptoId]
			FROM app620.RelPerfilEmpleadosConceptos REC2 WHERE REC2.Perfil_Ident = PE.Perfil_Ident
		) AS ConceptoId
		,CASE
			WHEN COUNT(CC.Descripcion) > 1
			THEN 'VARIOS'
			ELSE (	SELECT	Descripcion
					FROM	[app620].[RelPerfilEmpleadosConceptos] A WITH(NOLOCK)
							JOIN app620.CatConceptos B ON A.ConceptoId = B.ConceptoId
					WHERE	A.Perfil_Ident = PE.Perfil_Ident)
		 END AS Descripcion
	FROM app620.CatPerfilEmpleados PE
	JOIN app620.RelPerfilEmpleadosConceptos RPEC ON RPEC.Perfil_Ident = PE.Perfil_Ident 
	LEFT JOIN [app620].[CatConceptos] CC ON CC.ConceptoId = RPEC.ConceptoId
	GROUP BY PE.Perfil_Ident

	SELECT
		 Perfil.[Perfil_Ident]
		,[NombrePerfilEmpleados]
		,Perfil.[Country_Ident]
		,Pais.Country_Full_Name
		,ISNULL(CCVW.Id, -1) City_Ident
		,CCVW.Value City_Name
		,Perfil.[Location_Ident]
		,Location.full_name Location_Name
		,Perfil.[Program_Ident]
		,Program.Program_Name
		,Perfil.[Contract_Type_Ident]
		,Contract.Contract_Type
		,Perfil.TipoAccesoId
		,TipoAcceso.Descripcion TipoAcceso
		,Perfil.Active
		,PECli.Client_Ident
		,PECli.Client_Name
		,PEC.ConceptoId
		,PEC.Descripcion ConceptoNombre
	FROM [app620].[CatPerfilEmpleados] Perfil
	JOIN #TempPerfilEmpleadosClientes PECli ON PECli.Perfil_Ident = Perfil.Perfil_Ident
	JOIN #TempPerfilEmpleadosConceptos PEC ON PEC.Perfil_Ident = Perfil.Perfil_Ident
	LEFT JOIN [app620].[CatCountryVw] Pais ON Pais.[Country_Ident] = Perfil.Country_Ident
	LEFT JOIN [app620].[CatLocationVw] Location ON Location.Location_Ident = Perfil.Location_Ident
	LEFT JOIN [app620].[CatClientVw] Client ON Client.Client_Ident = Perfil.Client_Ident
	LEFT JOIN [app620].[CatProgramVw] Program ON Program.Program_Ident = perfil.Program_Ident
	LEFT JOIN [app620].[CatContractTypeVw] Contract ON Contract.Contract_Type_Ident = Perfil.Contract_Type_Ident
	LEFT JOIN [app620].[CatConceptos] Concepto ON Concepto.ConceptoId = Perfil.ConceptoId
	LEFT JOIN [app620].[CatTiposAcceso] TipoAcceso ON TipoAcceso.TipoAccesoId = Perfil.[TipoAccesoId]
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
			,PECli.Client_Ident
			,PECli.Client_Name
			,PEC.ConceptoId
			,PEC.Descripcion 
	ORDER BY NombrePerfilEmpleados

	DROP TABLE #TempPerfilEmpleadosClientes

	DROP TABLE #TempPerfilEmpleadosConceptos

END