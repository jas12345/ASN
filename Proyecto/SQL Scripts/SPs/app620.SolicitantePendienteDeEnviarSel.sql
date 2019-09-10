CREATE PROCEDURE app620.SolicitantePendienteDeEnviarSel
AS
	BEGIN
		SELECT	DISTINCT S.Solicitante_Ident
		FROM	app620.CatSolicitudes S WITH(NOLOCK)
		WHERE	S.EstatusSolicitudId IN ('EB','R')
	END