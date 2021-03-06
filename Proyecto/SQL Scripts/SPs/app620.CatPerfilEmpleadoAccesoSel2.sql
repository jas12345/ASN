USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadoAccesoSel]    Script Date: 29/05/2019 05:14:15 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[CatPerfilEmpleadoAccesoSel]
(
	  @Perfil_Ident		INT = -1
	 ,@Ident			INT = -1
	 --,@Activo			INT = 1
)
AS

BEGIN

	DECLARE
		  @Nombre					VARCHAR(752)
		, @Position_Code_Ident		INT
		, @Position_Code_Title		VARCHAR(150)
		, @Manager_Ident			INT
		, @Nombre_Manager			VARCHAR(752)
		, @NombrePerfilEmpleados	VARCHAR(50)
		, @TipoAccesoId				INT
		, @TipoAcceso				VARCHAR(50)
		, @Active 					BIT

	SELECT
			 @Ident			= ISNULL(@Ident, -1)
			,@Perfil_Ident	= ISNULL(@Perfil_Ident, -1)
			--,@Activo		= ISNULL(@Activo, 1)

	IF (@Ident <> -1) 
		SELECT
		  @Nombre = Emp.Nombre
		, @Position_Code_Ident	= Emp.Position_Code_Ident
		, @Position_Code_Title	= Emp.Position_Code_Title
		, @Manager_Ident		= Emp.Manager_Ident
	FROM
		app620.CatEmployeeCCMSVw AS Emp 
	WHERE
		Emp.Ident			= @Ident

	SELECT
		@Manager_Ident			= ISNULL(@Manager_Ident, -1)

	IF (@Manager_Ident <> -1) 
		SELECT
		  @Nombre_Manager		= Emp.Nombre
	FROM
		app620.CatEmployeeCCMSVw AS Emp 
	WHERE
		Emp.Ident			= @Manager_Ident

	IF (@Perfil_Ident <> -1)
		SELECT
			   @NombrePerfilEmpleados	= PE.NombrePerfilEmpleados
			  ,@TipoAccesoId			= PE.TipoAccesoId
			--, @Active					= Active
		FROM
			app620.CatPerfilEmpleados PE
		JOIN [app620].[CatPerfilEmpleadosAccesos] PEA ON PEA.Perfil_Ident = PE.Perfil_Ident
		WHERE PEA.Perfil_Ident		= @Perfil_Ident					
		AND PEA.EmpleadoId			= @Ident

		SELECT
			@Active					= Active
		FROM 
			 [app620].[CatPerfilEmpleadosAccesos] PEA
		WHERE
				PEA.[EmpleadoId]			= @Ident
			AND	PEA.[Perfil_Ident]			= @Perfil_Ident

		SELECT @TipoAcceso = Descripcion
		FROM
			CatTiposAcceso TA
		WHERE TA.TipoAccesoId = @TipoAccesoId


		--SELECT
		--	*
		--FROM 
		--	 [app620].[CatPerfilEmpleadosAccesos] PEA
		--WHERE
		--		PEA.[EmpleadoId]			= 137761
		--	AND	PEA.[Perfil_Ident]			= 1




	SELECT	@TipoAccesoId	= TipoAccesoId FROM app620.CatPerfilEmpleados WHERE Perfil_Ident = @Perfil_Ident
	SELECT	@TipoAccesoId	= ISNULL(@TipoAccesoId, -1)
	

	SELECT
		  @Ident					Ident
		, @Nombre					Nombre
		, @Position_Code_Ident		Position_Code_Ident
		, @Position_Code_Title		Position_Code_Title	
		, @Manager_Ident			Manager_Ident
		, @Nombre_Manager			Nombre_Manager	
		, @Perfil_Ident				Perfil_Ident
		, @NombrePerfilEmpleados	NombrePerfilEmpleados
		, @Active					Active
		, @TipoAccesoId				TipoAccesoId
		, @TipoAcceso				TipoAcceso
		--, @Activo					Activo
		, AccesoSolicitante =
								CASE WHEN
								(	-- Filtro para Solicitantes	
									@Position_Code_Title IS NOT NULL
								AND
									@Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
								AND
									@TipoAccesoId	= 1
								) 
								THEN
									1
								ELSE
									0
								END
		, AccesoAutorizante =
								CASE WHEN
								(	-- Filtro para Autorizantes	
									@Position_Code_Title IS NOT NULL
								AND
									@Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
								AND
									@TipoAccesoId	= 2

								) 
								THEN
									1
								ELSE
									0
								END
		, AccesoResponsable =
								CASE WHEN
								(	-- Filtro para Responsables	
									@Position_Code_Title IS NOT NULL
								AND
									@Position_Code_Title IN ('IMSS Coordinator', 'IMSS Manager', 'Payroll Coordinator', 'Payroll Manager', 'Payroll Specialist', 'Payroll Sr. Manager')
								AND	
									@TipoAccesoId	= 3

								) 
								THEN
									1
								ELSE
									0
								END
		, AccesoConsultante =
								CASE WHEN
								(	-- Filtro para Consultas	
									@Position_Code_Title IS NOT NULL
								AND
									@Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
								AND	
									@TipoAccesoId	= 4
								) 
								THEN
									1
								ELSE
									0
								END
		, AccesoOtros =
								CASE WHEN
								(	-- Filtro para Otros
									@Position_Code_Title IS NOT NULL
								AND
									@Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
								AND	
									@TipoAccesoId = -1

								) 
								THEN
									1
								ELSE
									0
								END

	--SELECT
	--	  Emp.Ident	
	--	, Emp.Nombre
	--	, Emp.Position_Code_Ident
	--	, Emp.Position_Code_Title
	--	, Perfil.Perfil_Ident
	--	, Perfil.NombrePerfilEmpleados
	--	, Perfil.Active PerfilActivo
	--	, PEA.Active PerfilEmpleadoAcceso_Activo

	--	, AccesoSolicitante =
	--							CASE WHEN
	--							(	-- Filtro para Solicitantes	
	--								Emp.Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
	--							AND
	--								Perfil.TipoAccesoId	= 1
	--							) 
	--							THEN
	--								1
	--							ELSE
	--								0
	--							END
	--	, AccesoAutorizante =
	--							CASE WHEN
	--							(	-- Filtro para Autorizantes	
	--								Emp.Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
	--							AND
	--								Perfil.TipoAccesoId	= 2

	--							) 
	--							THEN
	--								1
	--							ELSE
	--								0
	--							END
	--	, AccesoResponsable =
	--							CASE WHEN
	--							(	-- Filtro para Responsables	
	--								Emp.Position_Code_Title IN ('IMSS Coordinator', 'IMSS Manager', 'Payroll Coordinator', 'Payroll Manager', 'Payroll Specialist', 'Payroll Sr. Manager')
	--							AND	
	--								Perfil.TipoAccesoId	= 3

	--							) 
	--							THEN
	--								1
	--							ELSE
	--								0
	--							END
	--	, AccesoConsultante =
	--							CASE WHEN
	--							(	-- Filtro para Consultas	
	--								Emp.Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
	--							AND	
	--								Perfil.TipoAccesoId	= 4
	--							) 
	--							THEN
	--								1
	--							ELSE
	--								0
	--							END
	--	, AccesoOtros =
	--							CASE WHEN
	--							(	-- Filtro para Otros
	--								Emp.Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
	--							AND	
	--								@TipoAccesoId = -1

	--							) 
	--							THEN
	--								1
	--							ELSE
	--								0
	--							END

	--FROM
	--	app620.CatEmployeeCCMSVw AS Emp 
	--	JOIN app620.CatLocationVw AS Loc 
	--		ON Emp.Location_Ident = Loc.Location_Ident 
	--	JOIN app620.CatPerfilEmpleados Perfil
	--		ON	(Perfil.Perfil_Ident		= @Perfil_Ident)
			
	--	JOIN [app620].[CatPerfilEmpleadosAccesos] PEA
	--		ON	PEA.[EmpleadoId]			= Emp.Ident
	--		AND	PEA.[Perfil_Ident]			= Perfil.Perfil_Ident
	--		--AND	(PEA.Active = 1)

	--WHERE
	--	Emp.Current_Status			= 'Active'
	--AND
	--	(Emp.Ident = @Ident)

	--ORDER BY Emp.Nombre

END
