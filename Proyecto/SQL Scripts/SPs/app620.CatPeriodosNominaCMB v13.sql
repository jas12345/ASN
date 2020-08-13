USE [ASN]
GO

/****** Object:  StoredProcedure [app620].[CatPeriodosNominaCMB]    Script Date: 13/08/2020 10:59:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC  [app620].[CatPeriodosNominaCMB] 
	@Active INT = 1
AS
BEGIN
	SELECT @Active = ISNULL(@Active, 0)


--	SELECT 
--		 PeriodoNominaId Ident
--		,NombrePeriodo As Valor
--	FROM [app620].[CatPeriodosNomina]
--	WHERE 
--		-- Períodos Actual y Futuros
--		(
--				FechaCaptura >= getdate()
--			AND
--				@Active = 1
--		)
--	OR	-- Todos los Períodos Pasados
--		(
--				FechaCaptura < getdate()
--			AND
--				@Active = 2
--		)
--	OR	-- Todos los Períodos Futuros
--		(
--				FechaInicio > getdate()
--			AND
--				@Active = 3
--		)
--	OR	-- Períodos Actual y Pasados
--		(
--				FechaInicio <= getdate()
--			AND
--				@Active = 4
--		)
--	OR	-- Todos los Períodos
--		@Active = 0

--ORDER BY FechaInicio DESC;
--END



DECLARE @SqlQuery VARCHAR(1000)

select @SqlQuery = 'SELECT 
					PeriodoNominaId Ident
					,NombrePeriodo As Valor
					FROM [app620].[CatPeriodosNomina]'
	if(@Active =0)
	begin
		select @SqlQuery = @SqlQuery + ' ORDER BY FechaInicio DESC'
	end
	else if(@Active = 1) 
	begin
		select @SqlQuery = @SqlQuery + ' WHERE FechaCaptura >= getdate() ORDER BY FechaInicio asc'
	end
	else if(@Active =2)
	begin
		select @SqlQuery = @SqlQuery + ' WHERE FechaCaptura < getdate() ORDER BY FechaInicio DESC'
	end
	else if(@Active =3)
	begin
		select @SqlQuery = @SqlQuery + ' WHERE FechaInicio > getdate()	ORDER BY FechaInicio DESC'
	end
	else if(@Active =4)
	begin
		select @SqlQuery = @SqlQuery + ' WHERE FechaInicio <= getdate()	ORDER BY FechaInicio DESC'
	end

	exec (@SqlQuery)

end

GO

