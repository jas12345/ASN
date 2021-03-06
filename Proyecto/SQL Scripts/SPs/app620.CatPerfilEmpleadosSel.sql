USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosSel]    Script Date: 24/04/2019 04:31:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatPerfilEmpleadosSel]
	@Perfil_Ident INT = 0 
AS
BEGIN

	SELECT @Perfil_Ident = ISNULL(@Perfil_Ident, 0)

	SELECT
		 [Perfil_Ident]
		,[NombrePerfilEmpleados]
		,Perfil.[Country_Ident]
		,Pais.Country_Full_Name
		,[City_Ident]
		,[City_Ident] City_Name

		,Perfil.[Company_Ident]
		,Company.Company_Name
		,Perfil.[Location_Ident]
		,Location.full_name Location_Name
		,Perfil.[Client_Ident]
		,Client.Client_Name
		,Perfil.[Program_Ident]
		,Program.Program_Name
		,Perfil.[Contract_Type_Ident]
		,Contract.Contract_Type
		,Perfil.ConceptoId
		,Concepto.Descripcion Concepto
		,Perfil.TipoAccesoId
		,TipoAcceso.Descripcion TipoAcceso
		,Perfil.Active
	FROM [app620].[CatPerfilEmpleados] Perfil
	LEFT JOIN [app620].[CatCountryVw] Pais ON Pais.[Country_Ident] = Perfil.Country_Ident
	LEFT JOIN [app620].[CatCompanyVw] Company ON Company.Company_Ident = Perfil.Company_Ident
	LEFT JOIN [app620].[CatLocationVw] Location ON Location.Location_Ident = Perfil.Location_Ident
	LEFT JOIN [app620].[CatClientVw] Client ON client.Client_Ident = Perfil.Client_Ident
	LEFT JOIN [app620].[CatProgramVw] Program ON Program.Program_Ident = perfil.Perfil_Ident
	LEFT JOIN [app620].[CatContractTypeVw] Contract ON Contract.Contract_Type_Ident = Perfil.Program_Ident
	LEFT JOIN [app620].[CatConceptos] Concepto ON Concepto.ConceptoId = Perfil.ConceptoId
	LEFT JOIN [app620].[CatTiposAcceso] TipoAcceso ON TipoAcceso.TipoAccesoId = Perfil.[TipoAccesoId]
	WHERE (Perfil.Perfil_Ident = @Perfil_Ident OR @Perfil_Ident = 0)
END
