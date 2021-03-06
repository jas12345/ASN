USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilesDetalleSel]    Script Date: 17/02/2020 06:41:05 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[CatPerfilesDetalleSel]
AS
BEGIN
	SELECT
	a.Perfil_Ident
	,a.NombrePerfilEmpleados AS Perfil
	,b.EmpleadoId AS CCMSIDEmpleado
	,c.Nombre AS NombreEmpleado
	,b.Nivel
	,c.Position_Code_Title As Puesto
	FROM [app620].[CatPerfilEmpleados] a
	INNER JOIN [app620].[CatPerfilEmpleadosAccesos] b ON a.Perfil_Ident = b.Perfil_Ident
	INNER JOIN [app620].[CatEmployeeCCMSAllVw] c ON b.EmpleadoId = c.Ident
	WHERE a.Active = 1
	ORDER BY a.NombrePerfilEmpleados, c.Nombre
END