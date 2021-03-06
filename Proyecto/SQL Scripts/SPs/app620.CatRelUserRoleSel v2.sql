USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatRelUserRoleSel]    Script Date: 21/07/2019 05:45:43 p. m. ******/
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
	FROM [app620].[CatEmployeeCCMSVw] Emp
	JOIN CatPerfilEmpleadosAccesos PEA
	ON PEA.EmpleadoId = Emp.Ident
	JOIN CatPerfilEmpleados PE
	ON PE.Perfil_Ident = PEA.Perfil_Ident
	JOIN CatTiposAcceso TA
	ON TA.TipoAccesoId = PE.TipoAccesoId
	WHERE Emp.Ident = @CCMSID

	UNION

	SELECT R.Role
	FROM RelUserRole UR
	JOIN CatRole R
	ON R.CatRoleId = UR.CatRoleId
	WHERE UR.UserCCMSId = @CCMSID

END
