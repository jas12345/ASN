USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatPeriodosNominaCMB]    Script Date: 17/07/2019 12:24:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatPeriodosNominaCMB]
	@Active INT = 1
AS
BEGIN

	SELECT @Active = ISNULL(@Active, 1)

	--SELECT
	--	 PeriodoNominaId Ident --[PeriodicidadNominaId] Ident
	--	,[NombrePeriodo] Valor
	--FROM [app620].[CatPeriodosNomina]
	--WHERE (Active = @Active)

	SELECT --TOP 1
	PeriodoNominaId Ident,
	CAST(AnioId AS VARCHAR(11)) + '_' + [ConsecutivoId] Valor 
	from [app620].[CatPeriodosNomina] --WHERE convert(date,getdate()) between convert(date,FechaInicio) and convert(date,FechaFin) AND TipoPeriodo = 'O'
	WHERE PeriodicidadNominaId = 'C' AND TipoPeriodo = 'O'
	AND convert(date,getdate()) between convert(date,FechaInicio) and convert(date,FechaFin)
	--AND convert(date,getdate()) > convert(date,FechaFin) 
	--AND convert(date,getdate()) > convert(date,FechaInicio) 
	ORDER BY CreatedDate DESC
END
