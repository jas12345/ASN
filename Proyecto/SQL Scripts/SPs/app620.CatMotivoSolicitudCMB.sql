USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatMotivoSolicitudCMB]    Script Date: 01/07/2019 05:02:31 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatMotivoSolicitudCMB]
AS
BEGIN
	SELECT 
		[MotivosSolicitudId] AS Id
      ,[Descripcion] AS Valor
  FROM [ASN].[app620].[CatMotivosSolicitud]
END
