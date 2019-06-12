USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[EmpleadosxPerfilSel]    Script Date: 11/06/2019 11:08:11 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[CatConceptosxEmpleadoCMB]
(
	 @Ident			INT = -1
)
AS

BEGIN

	SELECT
			@Ident			= ISNULL(@Ident, -1)

	SELECT 
		 --DISTINCT
		 CC.ConceptoId As Ident
		,CC.Descripcion As Valor
	FROM app620.CatEmployeeCCMSVw Emp
	JOIN [ASN].[app620].[CatRelLocationBiosCCMSVw] LocBIOS
	ON
		LocBIOS.location_ccms = Emp.Location_Ident
	JOIN
		 app620.CatConceptos AS CC
	ON
		CHARINDEX(CAST(Emp.country_ident as varchar(50)), CC.PaisId) > 0

	JOIN app620.CatPerfilEmpleados Perfil
		ON	
			(Emp.country_ident			= Perfil.Country_Ident			OR	Perfil.Country_Ident		= -1)
		AND (Emp.Location_Ident			= Perfil.Location_Ident			OR	Perfil.Location_Ident		= -1)
		AND (Emp.Client_Ident			= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
		AND (Emp.Program_Ident			= Perfil.Program_Ident			OR	Perfil.Program_Ident		= -1)
		AND (Emp.Contract_Type_Ident	= Perfil.Contract_Type_Ident	OR	Perfil.Contract_Type_Ident	= -1)

	AND
		(LocBIOS.location_bios			= Perfil.City_Ident				OR	Perfil.City_Ident			= -1)
		
	AND
				(CC.ClienteId				= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
	AND
				(ISNULL(CC.ConceptoId, -1)	= Perfil.ConceptoId				OR	Perfil.ConceptoId			= -1)

		--JOIN [app620].[CatRelLocationBiosCCMSVw] LocBIOS
		--ON
		--	(LocBIOS.location_ccms			= Perfil.City_Ident				OR	Perfil.City_Ident			= -1)

		--AND	(Emp.Location_Ident			= Perfil.City_Ident				OR	Perfil.City_Ident		= -1)

		--	ON	(LocBIOS.[location_bios]	= Perfil.City_Ident				OR	Perfil.City_Ident			= -1)
		--JOIN [app620].[CatConceptos] CC 
		--	ON CC.ConceptoId = Perfil.ConceptoId
		--		(CC.ClienteId				= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
		--	AND
		--		(ISNULL(CC.ConceptoId, -1)	= Perfil.ConceptoId				OR	Perfil.ConceptoId			= -1)
	WHERE
		Emp.Ident = @Ident


		--CatConceptos.PaisId = Emp.country_ident
	--	CHARINDEX(CAST(Emp.country_ident as varchar(50)), CatConceptos.PaisId) > 0
	--AND
	--		AND

	--	--CatConceptos.ClienteId = Perfil.Client_Ident
	----AND
	----	Emp.Position_Code_Title NOT LIKE 'agent%' 
	----AND 
	----	Emp.Position_Code_Title NOT LIKE '%becario%'
END
