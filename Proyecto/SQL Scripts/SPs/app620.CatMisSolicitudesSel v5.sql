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
	--AND ES.EstatusSolicitudId IN ('R', 'EB', 'PA', 'CE')

 -- WHERE CS.[Active] = 1
 -- AND (CS.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

END