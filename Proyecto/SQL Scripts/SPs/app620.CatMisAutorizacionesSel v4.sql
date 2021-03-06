USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatMisAutorizacionesSel]    Script Date: 22/07/2019 06:10:08 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
		AND SEA.Autorizador_Ident = @Autorizante_Ident
	WHERE
		SEA.Autorizador_Ident = @Autorizante_Ident
	AND
		S.EstatusSolicitudId IN ('E')
END
