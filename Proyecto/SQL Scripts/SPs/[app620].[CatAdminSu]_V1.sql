USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatAdminSu]    Script Date: 9/12/2019 3:17:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatAdminSu]
@CCMSID int = 0 -- El usuario quien esta realizando el movimiento
,@UserCCMSID int = 0 -- A quien le da el perfil de admin
,@Active bit
,@RelUserRoleId int = 0
AS
BEGIN
	IF EXISTS(SELECT 1 FROM [app620].[RelUserRole] WHERE UserCCMSId = @UserCCMSID)
	BEGIN
		UPDATE [app620].[RelUserRole]
		SET Active = @Active
		WHERE RelUserRoleId = @RelUserRoleId
	END
END
