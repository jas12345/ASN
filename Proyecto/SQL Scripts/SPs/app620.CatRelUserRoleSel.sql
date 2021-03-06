USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatRelUserRoleSel]    Script Date: 03/06/2019 12:31:38 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
--*Objeto:				[CatRelUserRoleSel]
--*Autor:				Javier Raygoza
--*Fecha de creación:	Enero 09, 2017
--*Objetivo:			Obtiene los roles de un usuario por medio del CCMSID
--*Entrada:				NA
--*Salida:				NA
--*Precondiciones:		NA
--*Retorno:				NA
--*Revisiones:		
--*Movimiento - /XXX - Fecha del Movimiento 
-- [app620].[CatRelUserRoleSel] 844795
-- =============================================
ALTER PROC [app620].[CatRelUserRoleSel]
(
	@CCMSID int = 0
)
AS
BEGIN

	SELECT 'Desarrollo' Role
		FROM [app620].[CatEmployeeCCMSVw] a (nolock)
		WHERE a.Ident = @CCMSID

	--SELECT c.[Role]
	--FROM [app620].RelUserRole a (nolock)
	--INNER JOIN [app620].CatRole c (nolock) on a.CatRoleId = c.CatRoleId
	--WHERE a.UserCCMSID  = @CCMSID
	--AND a.Active = 1

	--UNION

	--SELECT 'ProDeproManager' Role
	--FROM [app620].[CatEmployeeCCMSVw] a (nolock)
	--INNER JOIN [app620].[CatEmployeeCCMSVw] b (nolock) on a.Manager_Ident = b.Ident
	--WHERE a.Manager_Ident = @CCMSID 
	--and a.Current_Status = 'Active'
	--and b.Ident not in (SELECT UserCCMSId FROM app620.RelUserRole WHERE Active = 1)
	----and position_code_ident = 248
	----and a.Location_Ident in (
	----459,
	----482,
	----631,
	----819
	----)

	--UNION

	--SELECT 'Report' Role
	--FROM [app620].[CatEmployeeCCMSVw] a (nolock)
	--INNER JOIN [app620].[CatEmployeeCCMSVw] b (nolock) on a.Manager_Ident = b.Ident
	--WHERE a.Manager_Ident = @CCMSID 
	--and a.Current_Status = 'Active'
	--and b.Ident not in (SELECT UserCCMSId FROM app620.RelUserRole WHERE Active = 1)
	--and a.country_ident = 239 -- Mexico

	--order by [Role]
END
