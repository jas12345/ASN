USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatAdminSel]    Script Date: 9/12/2019 3:16:26 PM ******/
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
