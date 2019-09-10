CREATE PROCEDURE app620.AutorizantePendienteDeAutorizarSel
AS
	BEGIN
		SELECT	SEA.Autorizador_Ident
		FROM	app620.CatSolicitudEmpleadosAutorizantes SEA WITH(NOLOCK)
		WHERE	SEA.Pendiente = 1
		GROUP BY SEA.Autorizador_Ident
	END