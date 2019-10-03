USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatMotivoSolicitudCMB]    Script Date: 01/10/2019 04:20:18 p. m. ******/
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
  FROM [app620].[CatMotivosSolicitud]
END
