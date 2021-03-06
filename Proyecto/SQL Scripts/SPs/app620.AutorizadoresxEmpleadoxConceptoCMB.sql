USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[AutorizadoresxConceptoCMB]    Script Date: 20/07/2019 05:21:38 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [app620].[AutorizadoresxEmpleadoxConceptoCMB]
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
		C.ConceptoId	= PE.ConceptoId
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
