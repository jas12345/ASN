USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatEmployeeSel]    Script Date: 01/10/2019 04:19:13 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Michell Cuni
-- Create date: 09-04-2019
-- Description:	SP que devuelve el listado de empleados con información
--				de la empresa, departamento, genero y correo
-- =============================================
ALTER PROCEDURE [app620].[CatEmployeeSel]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
		 [Ident]
		,[First_Name]
		,[Middle_Name]
		,[Last_Name]
		,[Location_Ident]
		,[Location_Name]
		,[Client_Ident]
		,[Client_Name]
		,[Program_Ident]
		,[Program_Name]
		,[Phone_Ident]
		,[Account_ID]
		,[position_code_company_name]
		,[Company_Ident]
		,[Company_Name]
		,[Departament]
		,[Departament_Ident]
		,[Gender]
		,[email1]
	  FROM [app620].[CatEmployeeCCMSVw]

END
