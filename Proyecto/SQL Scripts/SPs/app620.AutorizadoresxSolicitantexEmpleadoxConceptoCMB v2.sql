USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[AutorizadoresxEmpleadoxConceptoCMB]    Script Date: 20/07/2019 05:59:08 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[AutorizadoresxSolicitantexEmpleadoxConceptoCMB]
(
	 @SolicitanteIdent INT = 0
	,@EmpleadoIdent INT = 0
	,@ConceptoId INT = 0
	,@UserEmployeeId INT
)
AS

BEGIN
	SET @ConceptoId = ISNULL(@ConceptoId, 0)

	SELECT
		PEAA.EmpleadoId,
		EmpAut.Nombre 
	FROM
		CatPerfilEmpleadosAccesos PEAS
	
	JOIN
		CatPerfilEmpleados EmpSolicita
	ON EmpSolicita.Perfil_Ident = PEAS.Perfil_Ident
	AND (PEAS.EmpleadoId = @SolicitanteIdent OR @SolicitanteIdent = -1)
	AND EmpSolicita.Active = 1
	AND PEAS.Active = 1
	AND (EmpSolicita.ConceptoId = @ConceptoId OR EmpSolicita.ConceptoId = -1)

	JOIN [app620].[CatEmployeeCCMSVw] Emp
	ON (Emp.Country_Ident = EmpSolicita.Country_Ident OR EmpSolicita.Country_Ident = -1)
	AND  (Emp.Location_Ident = EmpSolicita.Location_Ident OR EmpSolicita.Location_Ident = -1)
	AND  (Emp.Client_Ident = EmpSolicita.Client_Ident OR EmpSolicita.Client_Ident = -1)
	AND  (Emp.Program_Ident = EmpSolicita.Program_Ident OR EmpSolicita.Program_Ident = -1)
	AND  (Emp.Contract_Type_Ident = EmpSolicita.Contract_Type_Ident OR EmpSolicita.Contract_Type_Ident = -1)

	JOIN [app620].[CatRelLocationBiosCCMSVw] BiosCity 
	ON (BiosCity.location_bios = EmpSolicita.City_Ident  OR EmpSolicita.City_Ident = -1)
	AND (BiosCity.location_ccms = Emp.Location_Ident)

	AND Emp.Ident = @EmpleadoIdent

	JOIN
		[app620].[CatPerfilEmpleados] EmpAutoriza
	ON
		(EmpSolicita.Country_Ident			= EmpAutoriza.Country_Ident			OR EmpAutoriza.Country_Ident = -1)
	AND
		(EmpSolicita.City_Ident				= EmpAutoriza.City_Ident			OR EmpAutoriza.City_Ident = -1)
	AND
		(EmpSolicita.Location_Ident			= EmpAutoriza.Location_Ident		OR EmpAutoriza.Location_Ident = -1)
	AND
		(EmpSolicita.Client_Ident			= EmpAutoriza.Client_Ident			OR EmpAutoriza.Client_Ident = -1)
	AND
		(EmpSolicita.Program_Ident			= EmpAutoriza.Program_Ident			OR EmpAutoriza.Program_Ident = -1)
	AND
		(EmpSolicita.Contract_Type_Ident	= EmpAutoriza.Contract_Type_Ident	OR EmpAutoriza.Contract_Type_Ident = -1)
	AND
		(EmpSolicita.ConceptoId				= EmpAutoriza.ConceptoId			OR EmpAutoriza.ConceptoId IS NULL)
	AND 
		(EmpAutoriza.ConceptoId				= @ConceptoId						OR EmpAutoriza.ConceptoId = -1)
	AND
		EmpAutoriza.TipoAccesoId			= 2
	AND
		EmpAutoriza.Active					= 1

	JOIN [app620].[CatEmployeeCCMSVw] EmpAut
	ON (EmpAut.Country_Ident = EmpAutoriza.Country_Ident OR EmpAutoriza.Country_Ident = -1)
	AND  (EmpAut.Location_Ident = EmpAutoriza.Location_Ident OR EmpAutoriza.Location_Ident = -1)
	AND  (EmpAut.Client_Ident = EmpAutoriza.Client_Ident OR EmpAutoriza.Client_Ident = -1)
	AND  (EmpAut.Program_Ident = EmpAutoriza.Program_Ident OR EmpAutoriza.Program_Ident = -1)
	AND  (EmpAut.Contract_Type_Ident = EmpAutoriza.Contract_Type_Ident OR EmpAutoriza.Contract_Type_Ident = -1)

	JOIN [app620].[CatRelLocationBiosCCMSVw] BiosCityAut 
	ON (BiosCityAut.location_bios = EmpAutoriza.City_Ident  OR EmpAutoriza.City_Ident = -1)
	AND (BiosCityAut.location_ccms = EmpAut.Location_Ident)

	JOIN 
		CatPerfilEmpleadosAccesos PEAA
	ON
		PEAA.Perfil_Ident					= EmpAutoriza.Perfil_Ident
	AND
		PEAA.Active							= 1

		



	--SELECT DISTINCT 
	--	 PEA.EmpleadoId
	--	,Aut.Nombre
	--	, PE.ConceptoId
	--FROM
	--	CatPerfilEmpleados PE
	--JOIN 	 
	--	[app620].[CatEmployeeCCMSVw] Emp
	--ON 
	--	Emp.Ident		= @EmpleadoIdent
	--AND	(PE.Country_Ident = Emp.Country_Ident OR PE.Country_Ident = -1)
	--AND	(PE.Location_Ident = Emp.Location_Ident OR PE.Location_Ident = -1)
	--AND	(PE.Client_Ident = Emp.Client_Ident OR PE.Client_Ident = -1)
	--AND	(PE.Program_Ident = Emp.Program_Ident OR PE.Program_Ident = -1)
	--AND (PE.Contract_Type_Ident = Emp.Contract_Type_Ident OR PE.Contract_Type_Ident = -1)
	--JOIN [app620].[CatRelLocationBiosCCMSVw] BiosCity 
	--ON (BiosCity.location_bios = PE.City_Ident  OR PE.City_Ident = -1)
	--AND (BiosCity.location_ccms = Emp.Location_Ident)
	--AND TipoAccesoId = 2	--Autorizantes

	--JOIN 
	--	CatConceptos C
	--ON 
	--	(C.ConceptoId	= PE.ConceptoId OR PE.ConceptoId = -1)
	--AND 
	--	C.ConceptoId	= @ConceptoId 


	--JOIN 
	--	[app620].[CatEmployeeCCMSVw] Aut
	--ON 
	--	Aut.Ident		= PEA.EmpleadoId

	--JOIN
	--	CatPerfilEmpleadosAccesos PEA
	--ON
	--	PEA.Perfil_Ident = PE.Perfil_Ident



	--WHERE 
	--	PEA.Active		= 1
	--AND PE.Active		= 1
	--AND C.Active		= 1
END
