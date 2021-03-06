USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[EmpleadosxPerfilSel2]    Script Date: 16/04/2019 06:05:35 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[EmpleadosxPerfilSel2]
(
	 @Perfil_Ident			INT = -1
)
AS

BEGIN

	SELECT
		 @Perfil_Ident			= ISNULL(@Perfil_Ident, -1)

	SELECT
		-- Emp.Ident,
		--Nombre,
		PE.Active
	
	FROM
		-- app620.CatEmployeeCCMSVw AS Emp 
		--,app620.CatPerfilEmpleados Perfil

		[app620].[CatPerfilEmpleados] PEA
		JOIN [app620].[CatPerfilEmpleadosAccesos] PE ON PE.Perfil_Ident = PEA.Perfil_Ident
		--LEFT JOIN app620.CatEmployeeCCMSVw AS Emp 
		--	ON 	(Emp.Company_Ident			= PEA.Company_Ident			OR	PEA.Company_Ident			= -1)
		--	AND (Emp.Location_Ident			= PEA.Location_Ident		OR	PEA.Location_Ident			= -1)
		--	AND (Emp.Client_Ident			= PEA.Client_Ident			OR	PEA.Client_Ident			= -1)
		--	AND (Emp.Program_Ident			= PEA.Program_Ident			OR	PEA.Program_Ident			= -1)
		--	AND (Emp.Contract_Type_Ident	= PEA.Contract_Type_Ident	OR	PEA.Contract_Type_Ident	= -1)

	WHERE
	--	Emp.Current_Status			= 'Active'
	--AND 
		(PEA.Perfil_Ident			= @Perfil_Ident				OR	@Perfil_Ident					= -1)

ORDER BY
		-- Emp.Ident,
		--Nombre,
		PE.Active

END
