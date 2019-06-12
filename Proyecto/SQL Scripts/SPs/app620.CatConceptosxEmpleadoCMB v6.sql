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
		--,Emp.[Client_Ident] 'Emp.Client_Ident'
		--,CC.ClienteId		'CC.ClienteId'

	FROM app620.CatEmployeeCCMSVw Emp
	JOIN
		 app620.CatConceptos AS CC
	ON
		CHARINDEX(CAST(Emp.country_ident as varchar(50)), CC.PaisId) > 0
	--AND
	--	Emp.[Client_Ident] = CC.ClienteId

	JOIN app620.CatPerfilEmpleados Perfil
		ON	
			(Emp.country_ident			= Perfil.Country_Ident			OR	Perfil.Country_Ident		= -1)
		AND (Emp.Location_Ident			= Perfil.Location_Ident			OR	Perfil.Location_Ident		= -1)
		AND (Emp.Client_Ident			= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
		AND (Emp.Program_Ident			= Perfil.Program_Ident			OR	Perfil.Program_Ident		= -1)
		AND (Emp.Contract_Type_Ident	= Perfil.Contract_Type_Ident	OR	Perfil.Contract_Type_Ident	= -1)

		AND (CC.ClienteId				= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
		AND (ISNULL(CC.ConceptoId, -1)	= Perfil.ConceptoId				OR	Perfil.ConceptoId			= -1)

	JOIN [ASN].[app620].[CatRelLocationBiosCCMSVw] LocBIOS
	ON
		LocBIOS.location_ccms = Emp.Location_Ident
	AND
		(LocBIOS.location_bios			= Perfil.City_Ident				OR	Perfil.City_Ident			= -1)

	WHERE
		Emp.Ident = @Ident
END
