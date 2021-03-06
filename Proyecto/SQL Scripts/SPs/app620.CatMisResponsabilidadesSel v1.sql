USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatMisResponsabilidadesSel]    Script Date: 24/08/2020 12:41:23 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatMisResponsabilidadesSel]
	@Responsable_Ident INT = 0
AS
BEGIN

	SET @Responsable_Ident = ISNULL(@Responsable_Ident, 0)

	SELECT		DISTINCT
				S.FolioSolicitud, S.Solicitante_Ident, S.Fecha_Solicitud, S.EstatusSolicitudId, ES.Descripcion AS EstatusSolicitud, '' AS Justificacion
				, S.PeriodoNominaId, PN.NombrePeriodo
	FROM   
		 [app620].[CatSolicitudes] S
	JOIN [app620].[CatEmpleadosSolicitudes] EMS ON 
			S.FolioSolicitud = EMS.FolioSolicitud
	JOIN app620.CatEmployeeCCMSVw EMP ON 
			EMP.Ident = EMS.Empleado_Ident


	----app620.CatPerfilEmpleados AS PER 
	--INNER JOIN app620.CatPerfilEmpleadosAccesos AS PEAccR ON 
	--		PEAccR.Perfil_Ident =  PER.Perfil_Ident


	JOIN app620.CatPerfilEmpleadosAccesos PEA ON 
			PEA.EmpleadoId = @Responsable_Ident
	JOIN app620.CatPerfilEmpleados PER ON 
			PER.Perfil_Ident = PEA.Perfil_Ident 

		AND 
			PER.Active = 1 
		AND 
			PER.TipoAccesoId = '3' 
		AND 
			(
				PEA.EmpleadoId = @Responsable_Ident 
			OR 
				@Responsable_Ident = 0
			)
		AND (EMP.Country_Ident			= PER.Country_Ident			OR PER.Country_Ident		= - 1) 
		AND (EMP.Location_Ident			= PER.Location_Ident		OR PER.Location_Ident		= - 1) 
		AND (EMP.Client_Ident			= PER.Client_Ident			OR PER.Client_Ident			= - 1) 
		AND (EMP.Program_Ident			= PER.Program_Ident			OR PER.Program_Ident		= - 1) 
		AND (EMP.Contract_Type_Ident	= PER.Contract_Type_Ident	OR PER.Contract_Type_Ident	= - 1) 

		JOIN [app620].[CatRelLocationBiosCCMSVw] BiosCity
		ON 
			(
				BiosCity.location_bios		= PER.City_Ident				
			OR
				PER.City_Ident = -1
			)

		AND (BiosCity.location_ccms		= EMP.Location_Ident)

		------INNER JOIN app620.CatPerfilEmpleados AS PES ON 
		------AND PES.Active = 1 
		------AND PES.TipoAccesoId = 1 
							 
	------INNER JOIN app620.CatPerfilEmpleadosAccesos AS PEAccS ON PEAccS.Perfil_Ident = PES.Perfil_Ident 
	------INNER JOIN app620.CatSolicitudes AS S ON S.Solicitante_Ident = PEAccS.EmpleadoId 
	INNER JOIN app620.CatEstatusSolicitudes AS ES ON ES.EstatusSolicitudId = S.EstatusSolicitudId

	LEFT JOIN [app620].[CatPeriodosNomina] PN
		ON PN.PeriodoNominaId = S.PeriodoNominaId
							 
	WHERE        (ES.EstatusSolicitudId IN ('CE','C', 'R', 'EB', 'A', 'PA')) ------AND (PER.EmpleadoId = @Responsable_Ident OR @Responsable_Ident = 0) 
	ORDER BY
		S.FolioSolicitud DESC

	--SELECT --* 
	--	S.FolioSolicitud, S.Solicitante_Ident, S.[Fecha_Solicitud], S.EstatusSolicitudId, ES.Descripcion EstatusSolicitud, '' Justificacion
	--FROM 
	--	app620.CatPerfilEmpleados PER

	---- Union con Perfiles de Responsables
	--JOIN
	--	app620.CatPerfilEmpleadosAccesos PEAccR
	--ON	PEAccR.Perfil_Ident		= PER.Perfil_Ident
	--AND	PER.Active				= 1
	--AND PER.TipoAccesoId		= '3'
	--AND PEAccR.EmpleadoId		= @Responsable_Ident

	---- Unión con Perfil de Solicitantes
	--JOIN app620.CatPerfilEmpleados PES 
	--ON
	--	(
	--			(PES.Country_Ident			= PER.Country_Ident			OR PER.Country_Ident		= -1)
	--		AND (PES.Location_Ident			= PER.Location_Ident		OR PER.Location_Ident		= -1)
	--		AND (PES.Client_Ident			= PER.Client_Ident			OR PER.Client_Ident			= -1)
	--		AND (PES.Program_Ident			= PER.Program_Ident			OR PER.Program_Ident		= -1)
	--		AND	(PES.Contract_Type_Ident	= PER.Contract_Type_Ident	OR PER.Contract_Type_Ident	= -1)
	--		AND	PES.Active					= 1
	--		AND PES.TipoAccesoId			= 1
	--		--JOIN [app620].[CatRelLocationBiosCCMSVw] BiosCity 
	--		--ON (BiosCity.location_bios = PE.City_Ident OR PE.City_Ident = -1)
	--		--AND (BiosCity.location_ccms = Emp.Location_Ident)
	--	)

	
	----Accesos de Solicitantes
	--JOIN
	--	app620.CatPerfilEmpleadosAccesos PEAccS
	--ON	PEAccS.Perfil_Ident		= PES.Perfil_Ident

	---- Accesos Solicitante en 
	--JOIN	CatSolicitudes S
	--ON		S.Solicitante_Ident	= PEAccS.EmpleadoId

	---- Descripción de los Estatus
	--JOIN [app620].[CatEstatusSolicitudes] ES
	--	ON ES.[EstatusSolicitudId] = S.[EstatusSolicitudId]

	----JOIN app620.CatPerfilEmpleadosAccesos PEAcc
	----ON PEAcc.EmpleadoId = S.Solicitante_Ident

	----JOIN app620.CatPerfilEmpleados PES
	----ON
	----	PES.Perfil_Ident = PEAcc.Perfil_Ident

	--WHERE (Solicitante_Ident = @Responsable_Ident OR @Responsable_Ident = 0)
	--AND ES.EstatusSolicitudId IN ('R', 'EB', 'A')

 -- WHERE CS.[Active] = 1
 -- AND (CS.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

END


