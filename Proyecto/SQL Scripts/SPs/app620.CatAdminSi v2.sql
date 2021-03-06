USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[CatAdminSi]    Script Date: 19/11/2019 05:37:20 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatAdminSi]
	 @CCMSID		int = 0 -- El usuario quien esta realizando el movimiento
	,@UserCCMSID	int = 0 -- A quien le da el perfil de admin
	,@Estatus		INT = 0 OUTPUT
AS
BEGIN
	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
	- 0 = Proceso sin error
	- -1 = Ya existe un registro con el mismo CCMSId
	*/

	IF NOT EXISTS(
		SELECT	1 
		FROM	[app620].[RelUserRole] 
		WHERE	UserCCMSId	= @UserCCMSID
	)
		BEGIN
			INSERT INTO [app620].[RelUserRole] (
				 UserCCMSId
				,CatRoleId
				,Active
				,CreatedBy
				,CreatedDate
				,LastModifiedBy
				,LastModifiedDate
				,LastModifiedFromPCName
			)
			VALUES (
				 @UserCCMSID
				,1
				,1
				,@CCMSID
				,getdate()
				,@CCMSID
				,getdate()
				,HOST_NAME()
			)
		END
	ELSE
		SET @Estatus = -1
END
