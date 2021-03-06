USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[AutorizadoresxEmpleadoxConceptoCMB]    Script Date: 20/07/2019 05:59:08 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [app620].[AutorizadoresxSolicitantexEmpleadoxConceptoCMB]
(
	  @SolicitanteIdent INT = 0
	  @EmpleadoIdent INT = 0
	 ,@ConceptoId INT = 0
)
AS

BEGIN
	SET @ConceptoId = ISNULL(@ConceptoId, 0)

	SELECT DISTINCT 
		 PEA.EmpleadoId
		,Aut.Nombre
		, PE.ConceptoId
	FROM
		CatPerfilEmpleados PE
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
	AND TipoAccesoId = 2	--Autorizantes

	JOIN 
		CatConceptos C
	ON 
		(C.ConceptoId	= PE.ConceptoId OR PE.ConceptoId = -1)
	AND 
		C.ConceptoId	= @ConceptoId 


	JOIN 
		[app620].[CatEmployeeCCMSVw] Aut
	ON 
		Aut.Ident		= PEA.EmpleadoId

	JOIN
		CatPerfilEmpleadosAccesos PEA
	ON
		PEA.Perfil_Ident = PE.Perfil_Ident



	WHERE 
		PEA.Active		= 1
	AND PE.Active		= 1
	AND C.Active		= 1
END
