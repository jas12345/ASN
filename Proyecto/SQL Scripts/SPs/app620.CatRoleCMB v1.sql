USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[CatRoleCMB]    Script Date: 17/09/2019 05:11:51 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatRoleCMB]
AS
BEGIN
	SELECT
	CatRoleId As Id,
	[Role] As Valor
	FROM [app620].[CatRole]
END
