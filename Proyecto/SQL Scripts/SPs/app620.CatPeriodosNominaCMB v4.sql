USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[CatPeriodosNominaCMB]    Script Date: 10/01/2020 07:51:34 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatPeriodosNominaCMB]
	@Active INT = 1
AS
BEGIN
	--SELECT @Active = ISNULL(@Active, 1)

	SELECT --TOP 1
	PeriodoNominaId Ident,
	--CAST(AnioId AS VARCHAR(11)) + '_' + [ConsecutivoId] Valor 
	NombrePeriodo As Valor
	from [app620].[CatPeriodosNomina]
	WHERE 
	--PeriodicidadNominaId = 'C' 
	--AND TipoPeriodo = 'O'
	--AND convert(date,getdate()) between convert(date,FechaInicio) and convert(date,FechaFin)
	convert(date,FechaInicio) >= convert(date,getdate()) OR @Active = 0
	ORDER BY NombrePeriodo DESC
END
