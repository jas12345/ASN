USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatMisAutorizacionesSel]    Script Date: 16/07/2019 04:05:37 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatMisAutorizacionesSel]
	@Autorizante_Ident INT = 0
AS
BEGIN

	SET @Autorizante_Ident = ISNULL(@Autorizante_Ident, 0)

SELECT --* 
	S.FolioSolicitud, S.Solicitante_Ident, S.[Fecha_Solicitud], S.EstatusSolicitudId, ES.Descripcion EstatusSolicitud, '' Justificacion
FROM CatSolicitudes S
JOIN [app620].[CatEstatusSolicitudes] ES
	ON ES.[EstatusSolicitudId] = S.[EstatusSolicitudId]
WHERE (Solicitante_Ident = @Autorizante_Ident OR @Autorizante_Ident = 0)

 -- WHERE CS.[Active] = 1
 -- AND (CS.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

END