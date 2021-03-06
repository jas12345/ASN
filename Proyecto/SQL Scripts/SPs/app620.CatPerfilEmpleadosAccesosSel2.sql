USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosAccesosSel2]    Script Date: 16/04/2019 05:52:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [app620].[CatPerfilEmpleadosAccesosSel2] 
	@Perfil_Ident INT =-1
AS
BEGIN
	SELECT	PEA.[Perfil_Ident], PE.[NombrePerfilEmpleados], Emp.Ident EmpleadoId, Emp.Nombre, PEA.Active

	--FROM	[app620].[CatPerfilEmpleadosAccesos] PEA
	--LEFT JOIN [app620].[CatEmployeeCCMSVw] Emp ON Emp.Ident = PEA.EmpleadoId
	--JOIN [app620].[CatPerfilEmpleados] PE ON PE.Perfil_Ident = PEA.Perfil_Ident

	--FROM	[app620].[CatEmployeeCCMSVw] Emp
	--LEFT JOIN [app620].[CatPerfilEmpleadosAccesos] PEA ON PEA.EmpleadoId = Emp.Ident
	--JOIN [app620].[CatPerfilEmpleados] PE ON PE.Perfil_Ident = PEA.Perfil_Ident




	FROM [app620].[CatPerfilEmpleadosAccesos] PEA
	JOIN [app620].[CatPerfilEmpleados] PE ON PE.Perfil_Ident = PEA.Perfil_Ident
	LEFT JOIN [app620].[CatEmployeeCCMSVw] Emp ON Emp.Ident = PEA.EmpleadoId

	WHERE	PEA.Perfil_Ident = @Perfil_Ident
	AND		Emp.Current_Status = 'Active'
END
