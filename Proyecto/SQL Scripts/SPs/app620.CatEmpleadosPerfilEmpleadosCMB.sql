USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatEmpleadosPerfilEmpleadosCMB]    Script Date: 23/05/2019 07:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jesús De los Santos
-- Create date: 18-04-2019
-- Description:	SP que devuelve el listado de empleados 
--				asociados al perfil.
-- =============================================
ALTER PROCEDURE [app620].[CatEmpleadosPerfilEmpleadosCMB]
	@Perfil_Ident	INT = -1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT @Perfil_Ident = ISNULL(@Perfil_Ident, -1)
	                                                                                              
	SELECT 
		  Emp.Ident AS Id
		, Emp.Nombre AS Value                                                                                                                                                                                                                                                    
	FROM [app620].[CatEmployeeCCMSVw] Emp                                    
	JOIN [CatPerfilEmpleados] Perfil
			ON	(Perfil.Perfil_Ident		= @Perfil_Ident					OR	@Perfil_Ident				= -1)

			--AND	(Emp.Company_Ident			= Perfil.Company_Ident			OR	Perfil.Company_Ident		= -1)
			AND (Emp.Location_Ident			= Perfil.Location_Ident			OR	Perfil.Location_Ident		= -1)
			AND (Emp.Client_Ident			= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
			AND (Emp.Program_Ident			= Perfil.Program_Ident			OR	Perfil.Program_Ident		= -1)
			AND (Emp.Contract_Type_Ident	= Perfil.Contract_Type_Ident	OR	Perfil.Contract_Type_Ident	= -1)

	WHERE
		Emp.Current_Status			= 'Active'



	--WHERE	(PE.Perfil_Ident	= @Perfil_Ident		OR @Perfil_Ident = -1)
	--AND		PE.Active			= 1

		--app620.CatEmployeeCCMSVw AS Emp 
		--JOIN app620.CatLocationVw AS Loc 
		--	ON Emp.Location_Ident = Loc.Location_Ident 
		--JOIN app620.CatPerfilEmpleados Perfil
		--	ON	(Perfil.Perfil_Ident		= @Perfil_Ident					OR	@Perfil_Ident				= -1)

		--	AND	(Emp.Company_Ident			= Perfil.Company_Ident			OR	Perfil.Company_Ident		= -1)
		--	AND (Emp.Location_Ident			= Perfil.Location_Ident			OR	Perfil.Location_Ident		= -1)
		--	AND (Emp.Client_Ident			= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
		--	AND (Emp.Program_Ident			= Perfil.Program_Ident			OR	Perfil.Program_Ident		= -1)
		--	AND (Emp.Contract_Type_Ident	= Perfil.Contract_Type_Ident	OR	Perfil.Contract_Type_Ident	= -1)

			--AND (Loc.country_ident			= Perfil.Country_Ident			OR	Perfil.Country_Ident		= -1)




END
