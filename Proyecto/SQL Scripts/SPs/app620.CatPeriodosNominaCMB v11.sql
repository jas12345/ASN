USE [ASN7]
GO
/****** Object:  StoredProcedure [app620].[CatPeriodosNominaCMB]    Script Date: 30/03/2020 06:41:42 p. m. ******/
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
				FechaCaptura >= getdate()
			AND
				@Active = 1
		)
	OR	-- Todos los Períodos Pasados
		(
				FechaCaptura < getdate()
			AND
				@Active = 2
		)
	OR	-- Todos los Períodos Futuros
		(
				FechaInicio > getdate()
			AND
				@Active = 3
		)
	OR	-- Períodos Actual y Pasados
		(
				FechaInicio <= getdate()
			AND
				@Active = 4
		)
	OR	-- Todos los Períodos
		@Active = 0
	ORDER BY NombrePeriodo DESC
END