USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatEmpleadoPuestoSupervisorSel]    Script Date: 07/06/2019 09:47:15 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[CatEmpleadoPuestoSupervisorSel]
(
	 --,@Perfil_Ident		INT = -1
	  @Ident			INT = -1
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
		, @Active 					BIT

	SELECT
			 @Ident			= ISNULL(@Ident, -1)

	--SELECT @Ident Ident

	IF (@Ident <> -1) 
		SELECT
		  @Nombre				=  Emp.Nombre				
		, @Position_Code_Ident	=  Emp.Position_Code_Ident	
		, @Position_Code_Title	=  Emp.Position_Code_Title	
		, @Manager_Ident		=  Emp.Manager_Ident		
		, @Nombre_Manager		=  Emp2.Nombre				
	FROM
		app620.CatEmployeeCCMSVw AS Emp 
	LEFT JOIN
		app620.CatEmployeeCCMSVw AS Emp2
	ON 
		Emp2.Ident	= Emp.Manager_Ident
	WHERE
		Emp.Ident			= @Ident

		SELECT
		  @Ident						Ident				
		, @Nombre						Nombre				
		, @Position_Code_Ident			Position_Code_Ident	
		, @Position_Code_Title			Position_Code_Title	
		, ISNULL(@Manager_Ident, -1)	Manager_Ident		
		, @Nombre_Manager				Nombre_Manager				

END
