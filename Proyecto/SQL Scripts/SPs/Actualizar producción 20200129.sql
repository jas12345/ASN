PRINT N'Alterando [app620].[CatMisSolicitudesSel]...';
GO

ALTER PROC [app620].[CatMisSolicitudesSel]
	@Solicitante_Ident INT = 0
AS
BEGIN

	SET @Solicitante_Ident = ISNULL(@Solicitante_Ident, 0)

	SELECT --* 
		S.FolioSolicitud, S.Solicitante_Ident, S.[Fecha_Solicitud], S.EstatusSolicitudId, ES.Descripcion EstatusSolicitud, '' Justificacion,
		S.PeriodoNominaId, PN.NombrePeriodo
	FROM CatSolicitudes S
	JOIN [app620].[CatEstatusSolicitudes] ES
		ON ES.[EstatusSolicitudId] = S.[EstatusSolicitudId]
	LEFT JOIN [app620].[CatPeriodosNomina] PN
		ON PN.PeriodoNominaId = S.PeriodoNominaId
	WHERE (Solicitante_Ident = @Solicitante_Ident OR @Solicitante_Ident = 0)
	order by s.FolioSolicitud desc
	--AND ES.EstatusSolicitudId IN ('R', 'EB', 'PA', 'CE')

 -- WHERE CS.[Active] = 1
 -- AND (CS.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

END
GO

PRINT N'Alterando [app620].[CatPeriodosNominaCMB]...';
GO

ALTER PROC [app620].[CatPeriodosNominaCMB]
	@Active INT = 1
AS
BEGIN
	SELECT @Active = ISNULL(@Active, 0)

	SELECT 
		 PeriodoNominaId Ident
		,NombrePeriodo As Valor
	FROM [app620].[CatPeriodosNomina]
	WHERE 
		-- Períodos Actual y Futuros
		(
				CONVERT(date,FechaFin) >= CONVERT(date,getdate())
			AND
				@Active = 1
		)
	OR	-- Todos los Períodos Pasados
		(
				CONVERT(date,FechaFin) < CONVERT(date,getdate())
			AND
				@Active = 2
		)
	OR	-- Todos los Períodos Futuros
		(
				CONVERT(date,FechaInicio) > CONVERT(date,getdate())
			AND
				@Active = 3
		)
	OR	-- Períodos Actual y Pasados
		(
				CONVERT(date,FechaInicio) <= CONVERT(date,getdate())
			AND
				@Active = 4
		)
	OR	-- Todos los Períodos
		@Active = 0
	ORDER BY NombrePeriodo DESC
END
GO

PRINT N'Creando [app620].[CatPeriodoNominaSolicitudSel]...';
GO

CREATE PROC [app620].[CatPeriodoNominaSolicitudSel]
	@FolioSolicitud INT = 0
AS
BEGIN
	SELECT
		 PN.PeriodoNominaId 
		,PN.NombrePeriodo
	FROM [app620].[CatPeriodosNomina] PN
	JOIN [app620].[CatSolicitudes] Sol
		ON Sol.PeriodoNominaId = PN.PeriodoNominaId
		AND Sol.FolioSolicitud = @FolioSolicitud
END
GO

PRINT N'Actualización completa.';
GO
