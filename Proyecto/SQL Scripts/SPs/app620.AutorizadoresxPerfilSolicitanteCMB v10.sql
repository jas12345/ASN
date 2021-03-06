USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[AutorizadoresxPerfilSolicitanteCMB]    Script Date: 14/09/2020 09:57:29 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [app620].[AutorizadoresxPerfilSolicitanteCMB]
(
	 @Perfil_Ident			INT = -1
)
AS

BEGIN

	SELECT
			@Perfil_Ident			= ISNULL(@Perfil_Ident, -1)

	SELECT DISTINCT 
		   PerfEmpAccesos.EmpleadoId	Id
		 , EmpAutorizante.Nombre		Value
	FROM
		[app620].[CatPerfilEmpleados] EmpSolicita
	JOIN
		app620.RelPerfilEmpleadosConceptos REC_S
	ON
		REC_S.Perfil_Ident = EmpSolicita.Perfil_Ident
	JOIN
		[app620].[CatPerfilEmpleados] EmpAutoriza
	ON
		(EmpSolicita.Country_Ident			= EmpAutoriza.Country_Ident			OR EmpAutoriza.Country_Ident = -1)
	AND
		(EmpSolicita.City_Ident				= EmpAutoriza.City_Ident			OR EmpAutoriza.City_Ident = -1)
	--AND
	--	(EmpSolicita.Company_Ident			= EmpAutoriza.Company_Ident			OR EmpAutoriza.Company_Ident = -1)
	AND
		(EmpSolicita.Location_Ident			= EmpAutoriza.Location_Ident		OR EmpAutoriza.Location_Ident = -1)
	AND
		(EmpSolicita.Client_Ident			= EmpAutoriza.Client_Ident			OR EmpAutoriza.Client_Ident = -1)
	AND
		(EmpSolicita.Program_Ident			= EmpAutoriza.Program_Ident			OR EmpAutoriza.Program_Ident = -1)
	--AND
	--	(EmpSolicita.Contract_Type_Ident	= EmpAutoriza.Contract_Type_Ident	OR EmpAutoriza.Contract_Type_Ident = -1)
	--AND
	--	(EmpSolicita.ConceptoId				= EmpAutoriza.ConceptoId			OR EmpAutoriza.ConceptoId IS NULL)
	--AND
	--	(EmpSolicita.Country_Ident = EmpAutoriza.Country_Ident OR EmpAutoriza.Country_Ident = -1)
	--AND
	--	(EmpSolicita.Country_Ident = EmpAutoriza.Country_Ident OR EmpAutoriza.Country_Ident = -1)
	--AND
	--	(EmpSolicita.Country_Ident = EmpAutoriza.Country_Ident OR EmpAutoriza.Country_Ident = -1)
	--AND
	JOIN
		app620.RelPerfilEmpleadosConceptos REC_A
	ON
		REC_A.Perfil_Ident = EmpAutoriza.Perfil_Ident
	AND
		REC_S.ConceptoId = REC_A.ConceptoId
	JOIN
		[app620].[CatPerfilEmpleadosAccesos] PerfEmpAccesos
	ON
		PerfEmpAccesos.Perfil_Ident = EmpAutoriza.Perfil_Ident
	JOIN
		[app620].[CatEmployeeCCMSVw] EmpAutorizante
	ON
		EmpAutorizante.Ident = PerfEmpAccesos.EmpleadoId

		----Adecuación de MultiCliente en RelPerfilEmpleadosClientes (Responsables)
	INNER JOIN	app620.RelPerfilEmpleadosClientes RECliRes
	ON			REC_A.Perfil_Ident	= RECliRes.Perfil_Ident 
	AND			(EmpSolicita.Client_Ident    = RECliRes.Client_Ident  or RECliRes.Client_Ident = '-1')

	WHERE
		(EmpSolicita.Perfil_Ident = @Perfil_Ident OR @Perfil_Ident = -1)
	AND
		EmpAutoriza.TipoAccesoId = 2
	AND
		EmpAutoriza.Active = 1
	--AND 
		--Emp.Position_Code_Title NOT LIKE 'agent%' 
		--Emp.Position_Code_Title NOT LIKE 'becario%'
END

