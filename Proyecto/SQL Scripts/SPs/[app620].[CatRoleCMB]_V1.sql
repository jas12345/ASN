USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatRoleCMB]    Script Date: 9/12/2019 3:17:37 PM ******/
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
