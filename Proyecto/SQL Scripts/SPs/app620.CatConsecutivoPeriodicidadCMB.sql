USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatConsecutivoPeriodicidadCMB]    Script Date: 19/03/2019 10:27:19 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[CatConsecutivoPeriodicidadCMB]
	@CatPeriodicidadNominaId nvarchar(5) = 'All'
AS
BEGIN

	SET @CatPeriodicidadNominaId = ISNULL(@CatPeriodicidadNominaId, 'All')

	SELECT
		 ConsecutivoId As Ident
		,ConsecutivoId AS Valor
	FROM [app620].[CatConsecutivoPeriodicidad]
	WHERE
		(
				@CatPeriodicidadNominaId = 'All'
			OR
				PeriodicidadNominaId = @CatPeriodicidadNominaId
		)
	AND Active = 1

END