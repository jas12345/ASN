USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[EmpleadosxPerfilSel]    Script Date: 07/05/2019 05:19:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[EmpleadosxPerfilSel]
(
	 @Perfil_Ident			INT = -1
)
AS

BEGIN

	SELECT
			@Perfil_Ident			= ISNULL(@Perfil_Ident, -1)

	SELECT
			Emp.Ident
		, Emp.Nombre
		, Emp.First_Name
		, Emp.Last_Name
		, Emp.Manager_Ident
		, Emp.Manager_First_Name
		, Emp.Manager_Last_Name

		, Emp.Program_Ident
		, Emp.Program_Name
		, Emp.Client_Ident
		, Emp.Client_Name
		, Emp.Company_Ident
		, Emp.Company_Name
		, Emp.Contract_Type_Ident
		, Emp.Contract_Type
		, Emp.Position_Code_Ident
		, Emp.Position_Code_Title

		, Loc.Location_Ident
		, Loc.full_name
		, Loc.country_ident
		, Loc.country_full_name
		, LocBIOS.[location_bios] city_Ident
		, LocBIOS.LocationName city
		, Emp.Current_Status
		,(CASE WHEN Perfil.ConceptoId IS NULL THEN 'TODOS' ELSE CC.Descripcion END) AS ConceptoNombre
	
	FROM
		app620.CatEmployeeCCMSVw AS Emp 
		JOIN app620.CatLocationVw AS Loc 
			ON Emp.Location_Ident = Loc.Location_Ident 
		JOIN app620.CatPerfilEmpleados Perfil
			ON	(Perfil.Perfil_Ident		= @Perfil_Ident					OR	@Perfil_Ident				= -1)

			AND	(Emp.Company_Ident			= Perfil.Company_Ident			OR	Perfil.Company_Ident		= -1)
			AND (Emp.Location_Ident			= Perfil.Location_Ident			OR	Perfil.Location_Ident		= -1)
			AND (Emp.Client_Ident			= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
			AND (Emp.Program_Ident			= Perfil.Program_Ident			OR	Perfil.Program_Ident		= -1)
			AND (Emp.Contract_Type_Ident	= Perfil.Contract_Type_Ident	OR	Perfil.Contract_Type_Ident	= -1)

			AND (Loc.country_ident			= Perfil.Country_Ident			OR	Perfil.Country_Ident		= -1)
		JOIN app620.CatRelLocationBiosCCMSVw LocBIOS
			ON	(LocBIOS.[location_bios]	= Perfil.City_Ident				OR	Perfil.City_Ident			= -1)
			AND	(LocBIOS.[location_ccms]	= Loc.Location_Ident)
		LEFT JOIN [app620].[CatConceptos] CC ON CC.ConceptoId = Perfil.ConceptoId
	WHERE
		Emp.Position_Code_Title NOT LIKE 'agent%' 
	AND 
		Emp.Position_Code_Title NOT LIKE 'becario%'
END
