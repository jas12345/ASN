USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[CatPeriodosNominaCMB]    Script Date: 17/07/2019 03:39:04 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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