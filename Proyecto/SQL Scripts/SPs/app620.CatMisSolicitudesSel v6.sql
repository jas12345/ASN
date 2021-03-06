USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatMisSolicitudesSel]    Script Date: 23/08/2019 05:19:53 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[CatMisSolicitudesSel]
	@Solicitante_Ident INT = 0
AS
BEGIN

	SET @Solicitante_Ident = ISNULL(@Solicitante_Ident, 0)

	SELECT --* 
		S.FolioSolicitud, S.Solicitante_Ident, S.[Fecha_Solicitud], S.EstatusSolicitudId, ES.Descripcion EstatusSolicitud, '' Justificacion
	FROM CatSolicitudes S
	JOIN [app620].[CatEstatusSolicitudes] ES
		ON ES.[EstatusSolicitudId] = S.[EstatusSolicitudId]
	WHERE (Solicitante_Ident = @Solicitante_Ident OR @Solicitante_Ident = 0)
	order by s.FolioSolicitud desc
	--AND ES.EstatusSolicitudId IN ('R', 'EB', 'PA', 'CE')

 -- WHERE CS.[Active] = 1
 -- AND (CS.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

END