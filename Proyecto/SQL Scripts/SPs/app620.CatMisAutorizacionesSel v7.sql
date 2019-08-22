ALTER PROC [app620].[CatMisAutorizacionesSel]
	@Autorizante_Ident INT = 0
AS
BEGIN

	SET @Autorizante_Ident = ISNULL(@Autorizante_Ident, 0)

	SELECT DISTINCT --* 
		S.FolioSolicitud, S.Solicitante_Ident, S.[Fecha_Solicitud], S.EstatusSolicitudId, ES.Descripcion EstatusSolicitud, '' Justificacion
		,SEA.Autorizador_Ident
	FROM CatSolicitudes S
	JOIN [app620].[CatEstatusSolicitudes] ES
		ON ES.[EstatusSolicitudId] = S.[EstatusSolicitudId]
	JOIN [app620].[CatEmpleadosSolicitudes] CES
		ON CES.FolioSolicitud = S.FolioSolicitud
	JOIN [app620].[CatSolicitudEmpleadosAutorizantes] SEA
		ON SEA.FolioSolicitud = CES.FolioSolicitud
		AND SEA.Empleado_Ident = CES.Empleado_Ident
		AND SEA.conceptoId = CES.ConceptoId
	WHERE
		SEA.Autorizador_Ident = @Autorizante_Ident
--	AND 
--		SEA.Pendiente = 1
--	AND
--		S.EstatusSolicitudId IN ('E', 'PA', 'R')
END

