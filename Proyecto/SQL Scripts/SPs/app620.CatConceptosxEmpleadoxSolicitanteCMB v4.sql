USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosxEmpleadoxSolicitanteCMB]    Script Date: 11/07/2019 05:40:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[CatConceptosxEmpleadoxSolicitanteCMB]
(
	  @Ident				INT = -1
	 ,@Ident_Solicitante	INT = -1
)
AS

BEGIN
	SELECT
			@Ident			= ISNULL(@Ident, -1)


	SELECT	PE.Perfil_Ident, PE.NombrePerfilEmpleados, PE.* 
	FROM	CatPerfilEmpleados PE
	JOIN	CatPerfilEmpleadosAccesos PEA 
	ON	PEA.Perfil_Ident = PE.Perfil_Ident
	WHERE PEA.EmpleadoId = @Ident_Solicitante	-- Id Solicitante
	AND TipoAccesoId = 1						--Solicitantes


	SELECT 
		 --DISTINCT
		 CC.ConceptoId As Ident
		,CC.Descripcion As Valor, CC.*


		--,Emp.[Client_Ident] 'Emp.Client_Ident'
		--,CC.ClienteId		'CC.ClienteId'

	FROM app620.CatConceptos AS CC
	JOIN
		 app620.CatEmployeeCCMSVw Emp
	ON
		CHARINDEX(CAST(Emp.country_ident as varchar(50)), CC.PaisId) > 0
	AND
		Emp.[Client_Ident] = CC.ClienteId

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

	--JOIN CatPerfilEmpleadosAccesos PEA							--Sección que conecta con los Perfiles asociados a permisos del solicitante
	--ON	
	--	PEA.Perfil_Ident				= Perfil.Perfil_Ident
	--AND
	--	PEA.EmpleadoId					= @Ident_Solicitante	-- Id Solicitante
	--AND 
	--	Perfil.TipoAccesoId				= 1						--Tipo de acceso Solicitantes
	--AND
	--	PEA.Active						= 1						-- Permiso activo para solicitante

	WHERE
		Emp.Ident = @Ident
END
