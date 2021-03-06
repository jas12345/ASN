USE [ASN_PE]
GO
/****** Object:  StoredProcedure [app620].[CatMisResponsabilidadesSel]    Script Date: 18/06/2020 10:28:11 a. m. ******/
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
	FROM            app620.CatPerfilEmpleados AS PER 
	INNER JOIN app620.CatPerfilEmpleadosAccesos AS PEAccR ON PEAccR.Perfil_Ident = PER.Perfil_Ident 
		AND PER.Active = 1 
		AND PER.TipoAccesoId = '3' 
		AND PEAccR.EmpleadoId = @Responsable_Ident 

	INNER JOIN app620.CatPerfilEmpleados AS PES ON (PES.Country_Ident = PER.Country_Ident OR PES.Country_Ident = - 1 OR PER.Country_Ident = - 1) 
		AND (PES.Location_Ident = PER.Location_Ident OR PES.Location_Ident = - 1 OR PER.Location_Ident = - 1) 
		--AND (PES.Client_Ident = PER.Client_Ident OR PES.Client_Ident = - 1 OR PER.Client_Ident = - 1) 
		AND (PES.Program_Ident = PER.Program_Ident OR PES.Program_Ident = - 1 OR PER.Program_Ident = - 1) 
		AND (PES.Contract_Type_Ident = PER.Contract_Type_Ident OR PES.Contract_Type_Ident = - 1 OR PER.Contract_Type_Ident = - 1) 
		AND PES.Active = 1 
		AND PES.TipoAccesoId = 1 
							 
	INNER JOIN app620.CatPerfilEmpleadosAccesos AS PEAccS ON PEAccS.Perfil_Ident = PES.Perfil_Ident 

	----Adecuación de MultiCliente en RelPerfilEmpleadosClientes (Responsables)
	--JOIN app620.RelPerfilEmpleadosClientes RECliRes
	--ON
	--	RECliRes.Perfil_Ident	= PER.Perfil_Ident

	----Adecuación de MultiCliente en RelPerfilEmpleadosClientes (Solicitantes)
	--JOIN app620.RelPerfilEmpleadosClientes RECliSol
	--ON
	--	RECliSol.Perfil_Ident	= PES.Perfil_Ident
	--AND
	--	RECliSol.Client_Ident	= RECliRes.Client_Ident

	INNER JOIN app620.CatSolicitudes AS S ON S.Solicitante_Ident = PEAccS.EmpleadoId 
	INNER JOIN app620.CatEstatusSolicitudes AS ES ON ES.EstatusSolicitudId = S.EstatusSolicitudId
							 
	JOIN [app620].[CatRelLocationBiosCCMSVw] BiosCity 
	ON (BiosCity.location_bios = PER.City_Ident OR PER.City_Ident = -1)
		AND (BiosCity.location_ccms = PER.Location_Ident OR PER.Location_Ident = -1)

	WHERE        (ES.EstatusSolicitudId IN ('CE','C', 'R', 'EB', 'A', 'PA')) AND (PEAccR.EmpleadoId = @Responsable_Ident OR @Responsable_Ident = 0) 
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
