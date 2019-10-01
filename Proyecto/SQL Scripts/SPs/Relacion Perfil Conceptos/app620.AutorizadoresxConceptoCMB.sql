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
	AND
		PE.TipoAccesoId	= 2
	JOIN
		app620.RelPerfilEmpleadosConceptos REC
	ON
		REC.Perfil_Ident = PE.Perfil_Ident
	AND
		REC.ConceptoId	= ISNULL(NULLIF(@ConceptoId,0),REC.ConceptoId)
	JOIN
		CatConceptos C
	ON
		C.ConceptoId	= REC.ConceptoId
	JOIN
		[app620].[CatEmployeeCCMSVw] Emp
	ON
		Emp.Ident		= PEA.EmpleadoId
	WHERE 
		PEA.Active		= 1
	AND PE.Active		= 1
	AND C.Active		= 1
END