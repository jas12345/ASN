USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatRelUserRoleSel]    Script Date: 29/10/2019 05:23:03 p. m. ******/
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

	SELECT DISTINCT TA.Descripcion Role
	FROM app620.[CatEmployeeCCMSVw] Emp
	JOIN app620.CatPerfilEmpleadosAccesos PEA
	ON PEA.EmpleadoId = Emp.Ident
	JOIN app620.CatPerfilEmpleados PE
	ON PE.Perfil_Ident = PEA.Perfil_Ident
	JOIN app620.CatTiposAcceso TA
	ON TA.TipoAccesoId = PE.TipoAccesoId
	WHERE Emp.Ident = @CCMSID
	AND PEA.Active = 1
	AND PE.Active = 1

	UNION

	SELECT R.Role
	FROM app620.RelUserRole UR
	JOIN app620.CatRole R
	ON R.CatRoleId = UR.CatRoleId
	WHERE UR.UserCCMSId = @CCMSID
	AND R.Active = 1
	AND UR.Active = 1

END
