USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatMisAutorizacionesSel]    Script Date: 30/07/2019 03:29:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatMisResponsabilidadesSel]
	@Responsable_Ident INT = 0
AS
BEGIN

	SET @Responsable_Ident = ISNULL(@Responsable_Ident, 0)

	SELECT DISTINCT --* 
		S.FolioSolicitud, S.Solicitante_Ident, S.[Fecha_Solicitud], S.EstatusSolicitudId, ES.Descripcion EstatusSolicitud, '' Justificacion
		,SEA.Autorizador_Ident
	FROM CatSolicitudes S
	JOIN [app620].[CatEstatusSolicitudes] ES
		ON ES.[EstatusSolicitudId] = S.[EstatusSolicitudId]
	JOIN [app620].[CatEmpleadosSolicitudes] CES
		ON CES.FolioSolicitud = S.FolioSolicitud
	JOIN [app620].[CatSolicitudEmpleadosAutorizantes] SEA
		ON SEA.FolioSolicitud = CES.FolioSolicitud
		AND SEA.Empleado_Ident = CES.Empleado_Ident
		AND SEA.conceptoId = CES.ConceptoId
	-- Filtro de Perfil Solicitante --> Perfil Responsable
	JOIN CatPerfilEmpleadosAccesos PEA
	ON PEA.EmpleadoId = S.Solicitante_Ident
	JOIN CatPerfilEmpleados PE
	ON PE.Perfil_Ident = PEA.Perfil_Ident
	AND PE.TipoAccesoId = 1
	JOIN CatPerfilEmpleados PER
	ON	

	--JOIN CatPerfilEmpleados PE
	--ON
		(PER.Country_Ident = PE.Country_Ident OR PER.Country_Ident = -1)
	AND (PER.Location_Ident = PE.Location_Ident OR PER.Location_Ident = -1)
	AND (PER.Client_Ident = PE.Client_Ident OR PER.Client_Ident = -1)
	AND (PER.Program_Ident = PE.Program_Ident OR PER.Program_Ident = -1)
	AND	(PER.Contract_Type_Ident = PE.Contract_Type_Ident OR PER.Contract_Type_Ident = -1)
	AND	PER.Active = 1
	JOIN [app620].[CatRelLocationBiosCCMSVw] BiosCity 
	ON (BiosCity.location_bios = PER.City_Ident  OR PER.City_Ident = -1)
	AND (BiosCity.location_ccms = PER.Location_Ident OR PER.Location_Ident = -1)




		)
	WHERE
	--	SEA.Autorizador_Ident = @Responsable_Ident
	--AND 
	--	SEA.Pendiente = 1
	--AND
		S.EstatusSolicitudId IN ('PA', 'A')
END
