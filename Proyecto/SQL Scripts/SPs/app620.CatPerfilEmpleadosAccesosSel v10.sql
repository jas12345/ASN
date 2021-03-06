USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosAccesosSel]    Script Date: 19/06/2019 07:41:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[CatPerfilEmpleadosAccesosSel]
(
	 @Perfil_Ident			INT = -1
)
AS

BEGIN

	DECLARE	@TipoAccesoId	INT

	SELECT
		 @Perfil_Ident			= ISNULL(@Perfil_Ident, -1)

	SELECT	@TipoAccesoId	= TipoAccesoId FROM app620.CatPerfilEmpleados WHERE Perfil_Ident = @Perfil_Ident
	SELECT	@TipoAccesoId	= ISNULL(@TipoAccesoId, -1)
	
	SELECT
		  Emp.Ident
		, Emp.Nombre
		, Emp.Position_Code_Ident
		, Emp.Position_Code_Title
		, Perfil.Perfil_Ident
		, Perfil.NombrePerfilEmpleados
		, Perfil.Active PerfilActivo
		, PEA.Active PerfilEmpleadoAcceso_Activo
		, PEA.Nivel
	
	FROM
		app620.CatEmployeeCCMSVw AS Emp 
		JOIN app620.CatLocationVw AS Loc 
			ON Emp.Location_Ident = Loc.Location_Ident 
		JOIN app620.CatPerfilEmpleados Perfil
			ON	(Perfil.Perfil_Ident		= @Perfil_Ident					OR	@Perfil_Ident				= -1)
			
		--	--AND	(Emp.Company_Ident			= Perfil.Company_Ident			OR	Perfil.Company_Ident		= -1)
		--	AND (Emp.Location_Ident			= Perfil.Location_Ident			OR	Perfil.Location_Ident		= -1)
		--	AND (Emp.Client_Ident			= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
		--	AND (Emp.Program_Ident			= Perfil.Program_Ident			OR	Perfil.Program_Ident		= -1)
		--	AND (Emp.Contract_Type_Ident	= Perfil.Contract_Type_Ident	OR	Perfil.Contract_Type_Ident	= -1)

		--	AND (Loc.country_ident			= Perfil.Country_Ident			OR	Perfil.Country_Ident		= -1)

		JOIN app620.CatRelLocationBiosCCMSVw LocBIOS
			ON	(LocBIOS.[location_ccms]	= Loc.Location_Ident)
			--AND	(LocBIOS.[location_bios]	= Perfil.City_Ident				OR	Perfil.City_Ident			= -1)

		--,app620.CatPerfilEmpleados Perfil
		--LEFT JOIN [app620].[CatPerfilEmpleadosAccesos] PEA
		JOIN [app620].[CatPerfilEmpleadosAccesos] PEA
			ON	PEA.[EmpleadoId]			= Emp.Ident
			AND	PEA.[Perfil_Ident]			= Perfil.Perfil_Ident
			AND	PEA.Active = 1

	WHERE
		Emp.Current_Status			= 'Active'
	AND 
		(
			(	-- Filtro para Solicitantes
				Emp.Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
			AND
				@TipoAccesoId	= 1
			)
			OR
			(	-- Filtro para Autorizantes
				Emp.Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
			AND
				@TipoAccesoId	= 2
			)
			OR
			(	-- Filtro para Responsables
				Emp.Position_Code_Title IN ('IMSS Coordinator', 'IMSS Manager', 'Payroll Coordinator', 'Payroll Manager', 'Payroll Specialist', 'Payroll Sr. Manager')
			AND	
				@TipoAccesoId	= 3
			)
			OR
			(	-- Filtro para Consultas
				Emp.Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
			AND	
				@TipoAccesoId	= 4
			)
			OR
			(	-- Filtro para Otros
				Emp.Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
			AND	
				@TipoAccesoId = -1
			)				
		)
	ORDER BY Emp.Nombre
	--AND
	--	PEA.Active = 1
END
