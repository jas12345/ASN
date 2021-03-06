USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[CatAdministradorInfoSel]    Script Date: 19/11/2019 04:55:55 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[CatAdministradorInfoSel]
	 @CCMSID int
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	IF NOT EXISTS	
			(
				SELECT 1
				FROM [app620].[CatPerfilEmpleados] 
				WHERE [NombrePerfilEmpleados] = @NombrePerfilEmpleados
			)

		BEGIN

			SELECT
			Nombre,
			ident as CCMSID,
			Location_Ident,
			Location_Name,
			Program_Ident,
			[Program_Name],
			Client_Ident,
			Client_Name,
			Contract_Type,
			Contract_Type_Ident,
			First_Name,
			Last_Name,
			Middle_Name,
			Hire_Date
			FROM [app620].[CatEmployeeCCMSVw]
			WHERE Ident = @CCMSID
		END
	ELSE
			SET @Estatus = -1
	END
END
