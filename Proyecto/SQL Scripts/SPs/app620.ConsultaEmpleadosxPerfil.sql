USE [ASN]
GO
/****** Object:  StoredProcedure [dbo].[ConsultaEmpleadosxPerfil]    Script Date: 17/04/2019 04:54:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [app620].[ConsultaEmpleadosxPerfil]
(
	 @Company_Ident			INT = -1
	,@Location_Ident		INT = -1
	,@Client_Ident			INT = -1
	,@Program_Ident			INT = -1
	,@Contract_Type_Ident	INT = -1

	,@City_Ident			VARCHAR = '-1'
	,@Country_Ident			INT = -1
)
AS

BEGIN

	SELECT
		 @Company_Ident			= ISNULL(@Company_Ident, -1)
		,@Location_Ident		= ISNULL(@Location_Ident, -1)
		,@Client_Ident			= ISNULL(@Client_Ident, -1)
		,@Program_Ident			= ISNULL(@Program_Ident, -1)
		,@Contract_Type_Ident	= ISNULL(@Contract_Type_Ident, -1)

		,@City_Ident			= ISNULL(@City_Ident, '-1')
		,@Country_Ident			= ISNULL(@Country_Ident, -1)

	SELECT
		  Perfil.Perfil_Ident
		, Perfil.NombrePerfilEmpleados
		, Emp.Ident
		, Emp.Nombre
		, Emp.First_Name
		, Emp.Last_Name
		, Emp.Manager_Ident
		, Emp.Manager_First_Name
		, Emp.Manager_Last_Name
		, Perfil.ConceptoId
		, Perfil.TipoAccesoId
		, Perfil.Active
		, Perfil.Program_Ident
		, Emp.Program_Name
		, Perfil.Client_Ident
		, Emp.Client_Name
		, Perfil.Location_Ident
		, Loc.full_name
		, Perfil.Company_Ident
		, Emp.Company_Name
		, Perfil.City_Ident
		, Loc.city
		, Perfil.Country_Ident
		, Loc.country_full_name
		, Perfil.Contract_Type_Ident
		, Emp.Contract_Type
	
	FROM
		 app620.CatPerfilEmpleados AS Perfil 
		--,app620.CatEmployeeCCMSVw AS Emp 
	LEFT JOIN app620.CatEmployeeCCMSVw AS Emp 
		ON Emp.Company_Ident = Perfil.Company_Ident 
		--AND Emp.Location_Ident = Perfil.Location_Ident 
		--AND Emp.Client_Ident = Perfil.Client_Ident 
		--AND Emp.Program_Ident = Perfil.Program_Ident 
		--AND Emp.Contract_Type_Ident = Perfil.Contract_Type_Ident 
		,app620.CatLocationVw AS Loc 
	--LEFT JOIN app620.CatLocationVw AS Loc 
	--	ON Loc.Location_Ident = Perfil.Location_Ident 
		--AND Perfil.City_Ident COLLATE Latin1_General_CI_AS = Loc.city 
		--AND Perfil.Country_Ident = Loc.country_ident
	WHERE
		Emp.Current_Status			= 'Active'
	AND	(Emp.Company_Ident			= @Company_Ident		OR	@Company_Ident			= -1)
	AND (Emp.Location_Ident			= @Location_Ident		OR	@Location_Ident			= -1)
	AND (Emp.Client_Ident			= @Client_Ident			OR	@Client_Ident			= -1)
	AND (Emp.Program_Ident			= @Program_Ident		OR	@Program_Ident			= -1)
	AND (Emp.Contract_Type_Ident	= @Contract_Type_Ident	OR	@Contract_Type_Ident	= -1)

	AND (Loc.city					= @City_Ident			OR	@City_Ident				= '-1')
	AND (Loc.country_ident			= @Country_Ident		OR	@Country_Ident			= -1)
END
