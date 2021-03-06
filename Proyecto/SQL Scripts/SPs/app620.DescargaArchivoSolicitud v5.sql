USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[DescargaArchivoSolicitud]    Script Date: 25/06/2020 03:24:51 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[DescargaArchivoSolicitud]
	 @EmpleadoId INT
	,@Activos INT
	,@PeriodoNomina INT = NULL
AS
	BEGIN
		DECLARE
			@PeriodoNominaId INT = 0
			,@CurrentStatus VARCHAR(10)

		IF (ISNULL(@PeriodoNomina,0) = 0)
			SELECT	TOP 1 @PeriodoNomina = PeriodoNominaId
			FROM	[app620].[CatPeriodosNomina]
			WHERE	PeriodicidadNominaId = 'C' 
					AND TipoPeriodo = 'O'
					--AND convert(date,getdate()) between convert(date,FechaInicio) and convert(date,FechaFin)
					AND convert(date,getdate()) between convert(date,FechaInicio) and convert(date,FechaCierre)
			ORDER BY FechaInicio ASC		
		--SELECT @PeriodoNomina PeriodoNomina
		SELECT	' EMPLEADO' EMPLEADO,'CONCEPTO' CONCEPTO,'ACCION' ACCION,'UNIDAD' UNIDAD,'IMPORTE' IMPORTE,'PORCENTAJE' PORCENTAJE,'FECHA' FECHA,'INICIO' INICIO,'FIN' FIN,'FOLIO' FOLIO,'CONSECUENCIA' CONSECUENCIA,'CONTROL' CONTROL,'SEMANA' SEMANA
		UNION ALL
		SELECT	CONVERT(VARCHAR(20),EMS.Empleado_Ident) EMPLEADO,
				PS.Descripcion CONCEPTO,
				'' ACCION,
				CASE
					WHEN C.ParametroConceptoId IN (1,2)
					THEN CONVERT(VARCHAR(10),EMS.ParametroConceptoMonto)
					ELSE ''
				END UNIDAD,
				CASE
					WHEN C.ParametroConceptoId IN (3)
					THEN CONVERT(VARCHAR(10),EMS.ParametroConceptoMonto)
					ELSE ''
				END IMPORTE,
				CASE
					WHEN C.ParametroConceptoId IN (4)
					THEN CONVERT(VARCHAR(10),EMS.ParametroConceptoMonto)
					ELSE ''
				END PORCENTAJE,
				'' FECHA,
				''	INICIO,
				''	FIN,
				''	FOLIO,
				''	CONSECUENCIA,
				''	CONTROL,
				''	SEMANA
				--,S.*
				--,E.country_ident
				--,E.country_full_name
				--,LB.location_bios
				--,LB.city
				--,E.Location_Ident
				--,E.Location_Name
				--,E.Client_Ident
				--,E.Client_Name
				--,E.Program_Ident
				--,E.Program_Name
				--,E.Contract_Type_Ident
				--,E.Contract_Type
				--,PE.Country_Ident
				--,PE.City_Ident
				--,LB.location_ccms
		FROM	[app620].[CatSolicitudes] S
				JOIN [app620].[CatEmpleadosSolicitudes] EMS ON S.FolioSolicitud = EMS.FolioSolicitud
				INNER JOIN [app620].[CatConceptos] C ON C.ConceptoId = EMS.ConceptoId
				INNER JOIN [app620].[CatConceptosPeopleSoft] PS ON PS.ConceptoId = C.PeopleSoftId
				LEFT JOIN [app620].[CatEmployeeCCMSAllVw] E ON E.Ident = EMS.[Empleado_Ident]
				INNER JOIN [app620].[CatLocationVw] AS b ON E.Location_Ident = b.Location_Ident
				INNER JOIN [ITAL].[app012].[RelLocationBiosCCMSVw] LB ON LB.location_ccms = E.Location_Ident
				INNER JOIN [app620].[CatPerfilEmpleados] PE ON	ISNULL(NULLIF(PE.Country_Ident, -1), b.country_ident) = b.country_ident AND 
																ISNULL(NULLIF(PE.City_Ident, -1), LB.location_bios) = LB.location_bios AND 
																ISNULL(NULLIF(PE.Location_Ident, -1), E.Location_Ident) = E.Location_Ident AND 
																--ISNULL(NULLIF(PE.Client_Ident, -1), E.Client_Ident) = E.Client_Ident AND
																ISNULL(NULLIF(PE.Program_Ident, -1),E.Program_Ident) = E.Program_Ident AND
																ISNULL(NULLIF(PE.Contract_Type_Ident, -1), E.Contract_Type_Ident) = E.Contract_Type_Ident
				INNER JOIN [app620].[CatPerfilEmpleadosAccesos] PEA ON PE.Perfil_Ident = PEA.Perfil_Ident
				INNER JOIN [app620].[CatPeriodosNomina] PN ON PN.PeriodoNominaId = S.PeriodoNominaId

				--Adecuación de MultiCliente en RelPerfilEmpleadosClientes
				JOIN app620.RelPerfilEmpleadosClientes RECli
				ON
					RECli.Perfil_Ident = PE.Perfil_Ident
				AND	
					RECli.Client_Ident = E.Client_Ident

		WHERE	
				S.EstatusSolicitudId = 'CE'
				AND S.Active = 1
				AND EMS.EstatusSolicitudId = 'CE'
				AND EMS.Active = 1
				AND PE.TipoAccesoId = 3
				AND PE.Active = 1
				AND PEA.Active = 1
				AND PN.PeriodoNominaId = @PeriodoNomina
				AND PEA.EmpleadoId = @EmpleadoId
				AND E.Current_Status IN (CASE WHEN @Activos = 1 THEN 'Active'  ELSE 'Terminated' END)
	END