ALTER PROCEDURE [app620].[AutorizadoresxEmpleadoxConceptoCMB]
(
	  @EmpleadoIdent INT = 0
	 ,@ConceptoId INT = 0
)
AS

BEGIN
	SET @ConceptoId = ISNULL(@ConceptoId, 0)

	SELECT DISTINCT 
		 PEA.EmpleadoId Id
		,Aut.Nombre		Valor
		--, PE.ConceptoId
	FROM
		 CatPerfilEmpleadosAccesos PEA
	JOIN
		CatPerfilEmpleados PE
	ON
		PE.Perfil_Ident = PEA.Perfil_Ident
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
		[app620].[CatEmployeeCCMSVw] Aut
	ON 
		Aut.Ident		= PEA.EmpleadoId
	JOIN 	 
		[app620].[CatEmployeeCCMSVw] Emp
	ON 
		Emp.Ident		= @EmpleadoIdent
	AND	(PE.Country_Ident = Emp.Country_Ident OR PE.Country_Ident = -1)
	AND	(PE.Location_Ident = Emp.Location_Ident OR PE.Location_Ident = -1)
	AND	(PE.Client_Ident = Emp.Client_Ident OR PE.Client_Ident = -1)
	AND	(PE.Program_Ident = Emp.Program_Ident OR PE.Program_Ident = -1)
	AND (PE.Contract_Type_Ident = Emp.Contract_Type_Ident OR PE.Contract_Type_Ident = -1)
	JOIN [app620].[CatRelLocationBiosCCMSVw] BiosCity 
	ON (BiosCity.location_bios = PE.City_Ident  OR PE.City_Ident = -1)
	AND (BiosCity.location_ccms = Emp.Location_Ident)

	WHERE 
		PEA.Active		= 1
	AND	PE.TipoAccesoId	= 2	--El perfil es de Autorizadores
	AND PE.Active		= 1
	AND C.Active		= 1	
END
GO

