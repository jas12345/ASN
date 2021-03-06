USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[CatAdminSel]    Script Date: 17/09/2019 05:15:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[CatAdminSel]
AS
BEGIN
	SELECT
	[RelUserRoleId], 
	[CatRoleId], 
	[UserCCMSId], 
	[Active],
	b.Nombre
	FROM [app620].[RelUserRole] a
	INNER JOIN [app620].[CatEmployeeCCMSVw] b on a.UserCCMSId = b.Ident
END
