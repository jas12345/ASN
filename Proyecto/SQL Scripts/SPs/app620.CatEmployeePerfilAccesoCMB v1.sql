USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatEmployeePerfilAccesoCMB]    Script Date: 01/10/2019 04:17:45 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jesús De los Santos Rodríguez
-- Create date: 01-07-2019
-- Description:	SP que devuelve el listado de empleados con acceso
--              según el perfil indicado
-- =============================================
ALTER PROCEDURE [app620].[CatEmployeePerfilAccesoCMB]
	@Perfil_Ident INT = 0 
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		 [Ident]
		,[Nombre]
	  FROM [app620].[CatEmployeeCCMSVw] Emp
	  JOIN CatPerfilEmpleadosAccesos PEA ON PEA.EmpleadoId = Emp.Ident
	  AND (PEA.Perfil_Ident = @Perfil_Ident OR @Perfil_Ident = 0)
	  AND PEA.Active = 1
END
