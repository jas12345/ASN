USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatEmployeeCMB]    Script Date: 01/10/2019 04:16:23 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jesús De los Santos Rodríguez
-- Create date: 09-04-2019
-- Description:	SP que devuelve el listado de empleados con información
--				de la empresa, departamento, genero y correo
-- =============================================
ALTER PROCEDURE [app620].[CatEmployeeCMB]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		 [Ident]
		,[Nombre]
	  FROM [app620].[CatEmployeeCCMSVw]
END
