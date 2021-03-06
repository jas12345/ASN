USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[AvisoSolicitantesAutorizantes]    Script Date: 07/05/2019 02:13:16 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[ToDoSolicitantesAutorizantesResponsables]

AS

BEGIN

	SELECT    S.FolioSolicitud
			, S.CreatedBy			Ident_Solicitante	, EmpSol.Nombre			Nombre_Solicitante	, EmpSol.email1			eMailSolicitante		, S.EstatusSolicitudId
			--, EmpSolicitud.Ident	Ident_Empleado		, EmpSolicitud.Nombre	Nombre_Empleado		, EmpSolicitud.email1	eMailEmpleado
			, SEA.Autorizador_Ident	Ident_Autorizante	, EmpAut.Nombre			Nombre_Autorizante	, EmpAut.email1			eMailAutorizante		
			, SEA.Autorizado, SEA.Rechazado, SEA.Cancelado

	INTO #SolicitantesAutorizantes
	FROM CatSolicitudes S 

	LEFT JOIN CatEmpleadosSolicitudes ES
	ON ES.FolioSolicitud = S.FolioSolicitud

	--AND	S.EstatusSolicitudId IN ('EB', 'R')
	
	JOIN [app620].[CatEmployeeCCMSVw] EmpSol
	ON EmpSol.Ident = S.CreatedBy

	JOIN [app620].[CatEmployeeCCMSVw] EmpSolicitud
	ON EmpSolicitud.Ident = ES.Empleado_Ident

	LEFT JOIN app620.CatSolicitudEmpleadosAutorizantes SEA
	ON SEA.FolioSolicitud = ES.FolioSolicitud
	AND SEA.Empleado_Ident = ES.Empleado_Ident

	LEFT JOIN [app620].[CatEmployeeCCMSVw] EmpAut
	ON EmpAut.Ident = SEA.Autorizador_Ident
	AND
		SEA.Autorizado = 0
	AND
		SEA.Rechazado = 0
	AND
		SEA.Cancelado = 0

	WHERE ES.Active = 1

	--AND	S.EstatusSolicitudId IN ('EB', 'R')
	
	SELECT	DISTINCT  FolioSolicitud
			, Ident_Solicitante			, Nombre_Solicitante		, eMailSolicitante		, EstatusSolicitudId
			--, NULL Ident_Empleado		, NULL Nombre_Empleado		, NULL eMailEmpleado
			, NULL Ident_Autorizante	, NULL Nombre_Autorizante	, NULL eMailAutorizante		
			, NULL Autorizado			, NULL Rechazado			, NULL Cancelado
			, NULL Ident_Responsable	, NULL Nombre_Responsable	, NULL eMailResponsable		
	FROM	#SolicitantesAutorizantes
	WHERE
			EstatusSolicitudId IN ('EB', 'R')
	UNION
	SELECT	DISTINCT  FolioSolicitud
			, NULL Ident_Solicitante	, NULL Nombre_Solicitante	, NULL eMailSolicitante		, EstatusSolicitudId
			--, NULL Ident_Empleado		, NULL Nombre_Empleado		, NULL eMailEmpleado
			, Ident_Autorizante			, Nombre_Autorizante		, eMailAutorizante		
			, Autorizado				, Rechazado					, Cancelado
			, NULL Ident_Responsable	, NULL Nombre_Responsable	, NULL eMailResponsable		
	FROM	#SolicitantesAutorizantes
	WHERE
			EstatusSolicitudId IN ('E', 'PA')
	AND
			Autorizado <> 1
	AND
			Rechazado <> 1					
	AND
			Cancelado <> 1
END
