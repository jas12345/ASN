USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatEmpleadosPerfilNivelAccesoSel]    Script Date: 01/07/2019 04:57:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jesús De los Santos Rodríguez
-- Create date: 01-07-2019
-- Description:	SP que devuelve el listado de empleados con acceso
--              según el perfil indicado
-- =============================================
ALTER PROCEDURE [app620].[CatEmpleadosPerfilNivelAccesoSel]
	@Perfil_Ident INT = 0 
AS
BEGIN
	SET NOCOUNT ON;


	SELECT 
		  Perfil_Ident
		, EmpleadoId
		, Nivel 
	FROM 
		CatPerfilEmpleadosAccesos 
	WHERE 
		(Perfil_Ident = @Perfil_Ident OR @Perfil_Ident = 0)
	AND 
		Active = 1 
	AND 
		Nivel IS NOT NULL
	ORDER BY 
		Nivel
END
