USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatEmpleadoPuestoSel]    Script Date: 26/06/2019 11:31:23 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[CatEmpleadoPuestoSel]
(
	  @Ident			INT = -1
)
AS

BEGIN

	DECLARE
		  @Nombre					VARCHAR(752)
		, @Position_Code_Ident		INT
		, @Position_Code_Title		VARCHAR(150)
		--, @Manager_Ident			INT
		--, @Nombre_Manager			VARCHAR(752)
		, @Contract_Type_Ident		INT
		, @Contract_Type			VARCHAR(50)
		, @Location_Ident			INT
		, @Location_Name			VARCHAR(250)

		, @Active 					BIT

	SELECT
			 @Ident			= ISNULL(@Ident, -1)

	--SELECT @Ident Ident

	IF (@Ident <> -1) 
		SELECT
		  Emp.Ident
		, Emp.Nombre				
		, Emp.Position_Code_Ident	
		, Emp.Position_Code_Title	
		, Emp.Contract_Type_Ident		
		, Emp.Contract_Type	
		, Emp.Location_Ident
		, Emp.Location_Name
		, Emp2.Ident IdentManager
		, Emp2.Nombre NombreManager
	FROM
		app620.CatEmployeeCCMSVw AS Emp 
	LEFT JOIN
		app620.CatEmployeeCCMSVw AS Emp2
	ON 
		Emp2.Ident	= Emp.Manager_Ident
	WHERE
		Emp.Ident			= @Ident

		--SELECT
		--  @Ident							Ident				
		--, @Nombre							Nombre				
		--, @Position_Code_Ident				Position_Code_Ident	
		--, @Position_Code_Title				Position_Code_Title	
		--, ISNULL(@Contract_Type_Ident, -1)	Contract_Type_Ident		
		--, @Contract_Type					Contract_Type				
		--, @Location_Ident					Location_Ident
		--, @Location_Name					Location_Name

END
