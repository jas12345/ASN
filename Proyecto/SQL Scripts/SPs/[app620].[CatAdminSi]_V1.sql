USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatAdminSi]    Script Date: 9/12/2019 3:16:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatAdminSi]
@CCMSID int = 0 -- El usuario quien esta realizando el movimiento
,@UserCCMSID int = 0 -- A quien le da el perfil de admin
AS
BEGIN
	IF NOT EXISTS( SELECT 1 FROM [app620].[RelUserRole] WHERE UserCCMSId = @UserCCMSID)
	BEGIN
		INSERT INTO [app620].[RelUserRole] (UserCCMSId,CatRoleId,Active,CreatedBy,CreatedDate,LastModifiedBy,LastModifiedDate,LastModifiedFromPCName)
		VALUES (@UserCCMSID,1,1,@CCMSID,getdate(),@CCMSID,getdate(),HOST_NAME())
	END
END
