USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[AutorizadoresxConceptoCMB]    Script Date: 25/07/2019 04:31:51 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[AutorizadoresxConceptoCMB]
(
	 @ConceptoId INT = 0
)
AS

BEGIN
	SET @ConceptoId = ISNULL(@ConceptoId, 0)

	SELECT DISTINCT 
		 PEA.EmpleadoId
		,Emp.Nombre
	FROM
		 CatPerfilEmpleadosAccesos PEA
	JOIN
		CatPerfilEmpleados PE
	ON
		PE.Perfil_Ident = PEA.Perfil_Ident
	JOIN 
		CatConceptos C
	ON 
		(C.ConceptoId	= PE.ConceptoId OR PE.ConceptoId IS NULL)
	JOIN 
		[app620].[CatEmployeeCCMSVw] Emp
	ON 
		Emp.Ident		= PEA.EmpleadoId
	WHERE 
		PEA.Active		= 1
	AND PE.Active		= 1
	AND C.Active		= 1
	AND (
			C.ConceptoId	= @ConceptoId 
		OR 
			@ConceptoId	= 0
		)
END
