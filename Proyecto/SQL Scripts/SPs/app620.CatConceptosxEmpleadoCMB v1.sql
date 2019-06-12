USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[EmpleadosxPerfilSel]    Script Date: 11/06/2019 11:08:11 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[CatConceptosxEmpleadoCMB2]
(
	 @Ident			INT = -1
)
AS

BEGIN

	SELECT
			@Ident			= ISNULL(@Ident, -1)

	SELECT 
		 Emp.Ident 'Emp.Ident'
		--,Perfil.Client_Ident 'Perfil.Client_Ident'
		,Perfil.NombrePerfilEmpleados 'Perfil.NombrePerfilEmpleados'
		,CatConceptos.PaisId 'CatConceptos.PaisId'
		,Emp.country_ident'Emp.country_ident'
		,Perfil.Country_Ident 'Perfil.Country_Ident'
		,CatConceptos.ClienteId 'CatConceptos.ClienteId'
		,Perfil.Client_Ident'Perfil.Client_Ident' 
		--,CC.ConceptoId 'CC.ConceptoId'
		,Perfil.ConceptoId 'Perfil.ConceptoId'
		,CC.ClienteId 'CC.ClienteId'
		,CC.ConceptoId 'CC.ConceptoId'
		,Loc.country_ident 'Loc.country_ident'
		,Emp.country_ident 'Emp.country_ident '
		,Emp.Location_Ident			'Emp.Location_Ident'
		,Perfil.Location_Ident 'Perfil.Location_Ident'
		,LocBIOS.[location_bios]	'LocBIOS.location_bios'
		,Perfil.City_Ident	'Perfil.City_Ident'
		,LocBIOS.[location_ccms]	'LocBIOS.location_ccms	'
		, Emp.Location_Ident 'Emp.Location_Ident'

		--,CatConceptos.ClienteId 'CatConceptos.ClienteId'
		--,CatConceptos.ConceptoId 'CatConceptos.ConceptoId'

		,Emp.Client_Ident 'Emp.Client_Ident'
		,Perfil.Client_Ident 'Perfil.Client_Ident'

		,Emp.Program_Ident 'Emp.Program_Ident'
		,Perfil.Program_Ident 'Perfil.Program_Ident'

		,Emp.Contract_Type_Ident 'Emp.Contract_Type_Ident'
		,Perfil.Contract_Type_Ident 'Perfil.Contract_Type_Ident'


		,CatConceptos.ClienteId 'CatConceptos.ClienteId'
		,Perfil.Client_Ident'Perfil.Client_Ident' 

		,CC.ConceptoId 'CC.ConceptoId'
		,CatConceptos.ConceptoId 'CatConceptos.ConceptoId'
		,Perfil.ConceptoId 'Perfil.ConceptoId'

		--,[app620].[CatConceptos].ClienteId 'CC.ClienteId'
		--,[app620].[CatConceptos].ConceptoId 'CC.ConceptoId'

		,Loc.country_ident 'Loc.country_ident'
		,Emp.country_ident 'Emp.country_ident '

		,Emp.Location_Ident 'Emp.Location_Ident'
		,Perfil.Location_Ident 'Perfil.Location_Ident'



		,
			 [CatConceptos].[ConceptoId] As Ident
			,[CatConceptos].[Descripcion] As Valor
		FROM [app620].[CatConceptos]
	JOIN
		app620.CatEmployeeCCMSVw Emp 
	ON
		CHARINDEX(CAST(Emp.country_ident as varchar(50)), app620.CatConceptos.PaisId) > 0

		JOIN app620.CatLocationVw AS Loc 
			ON Emp.Location_Ident = Loc.Location_Ident 
		JOIN app620.CatPerfilEmpleados Perfil
			ON	
				(Emp.Location_Ident			= Perfil.Location_Ident			OR	Perfil.Location_Ident		= -1)
			AND (Emp.Client_Ident			= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
			AND (Emp.Program_Ident			= Perfil.Program_Ident			OR	Perfil.Program_Ident		= -1)
			AND (Emp.Contract_Type_Ident	= Perfil.Contract_Type_Ident	OR	Perfil.Contract_Type_Ident	= -1)

			AND (Loc.country_ident			= Perfil.Country_Ident			OR	Perfil.Country_Ident		= -1)

		JOIN app620.CatRelLocationBiosCCMSVw LocBIOS
			ON	(LocBIOS.[location_bios]	= Perfil.City_Ident				OR	Perfil.City_Ident			= -1)
			AND	(LocBIOS.[location_ccms]	= Emp.Location_Ident)


		JOIN [app620].[CatConceptos] CC 
			ON CC.ConceptoId = Perfil.ConceptoId
			AND
				(CC.ClienteId				= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
			AND
				(ISNULL(CC.ConceptoId, -1)	= Perfil.ConceptoId				OR	Perfil.ConceptoId			= -1)

		--JOIN app620.CatRelLocationBiosCCMSVw LocBIOS
		--	ON	(LocBIOS.[location_bios]	= Perfil.City_Ident				OR	Perfil.City_Ident			= -1)
		--	AND	(LocBIOS.[location_ccms]	= Loc.Location_Ident)
		------JOIN [app620].[CatConceptos] CC 
		------	ON CC.ConceptoId = Perfil.ConceptoId
		------	AND
		------		(CC.ClienteId				= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
		------	AND
		------		(ISNULL(CC.ConceptoId, -1)	= Perfil.ConceptoId				OR	Perfil.ConceptoId			= -1)
	WHERE
		Emp.Ident = @Ident
	--AND
	--	CatConceptos.PaisId = Emp.country_ident

		--JOIN [app620].[CatConceptos] CC 
			--ON 
			--	[app620].[CatConceptos].ConceptoId = Perfil.ConceptoId
			--AND
	--			([app620].[CatConceptos].ClienteId				= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
	--		AND
	--			(ISNULL([app620].[CatConceptos].ConceptoId, -1)	= Perfil.ConceptoId				OR	Perfil.ConceptoId			= -1)
	--AND
		--CatConceptos.PaisId = Emp.country_ident
		--((CHARINDEX(CAST(Emp.country_ident as varchar(50)), CatConceptos.PaisId) > 0)				OR CatConceptos.PaisId = -1)
		--CatConceptos.ClienteId = Perfil.Client_Ident
	--AND
	--	Emp.Position_Code_Title NOT LIKE 'agent%' 
	--AND 
	--	Emp.Position_Code_Title NOT LIKE '%becario%'
END
