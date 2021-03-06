USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosCMB]    Script Date: 31/10/2019 05:01:29 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatPerfilEmpleadosCMB]
	@TipoAccesoId INT = '-1'
AS
BEGIN
	SET @TipoAccesoId = ISNULL(@TipoAccesoId, -1)

	SELECT DISTINCT
		 [Perfil_Ident] As Ident
		,[NombrePerfilEmpleados] As Valor
	FROM [app620].[CatPerfilEmpleados]
	WHERE Active = 1
	AND (TipoAccesoId = @TipoAccesoId OR @TipoAccesoId = -1)
	ORDER BY NombrePerfilEmpleados
END
