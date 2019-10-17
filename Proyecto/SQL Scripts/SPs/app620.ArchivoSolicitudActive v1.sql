CREATE PROC [app620].[ArchivoSolicitudActive]
AS
	BEGIN
		DECLARE
			@PeriodoNominaId INT = 0
			,@CurrentStatus VARCHAR(10)

		SELECT	@PeriodoNominaId = PeriodoNominaId
		FROM	[app620].[CatPeriodosNomina]
		WHERE	PeriodicidadNominaId = 'C' 
				AND TipoPeriodo = 'O'
				AND convert(date,getdate()) between convert(date,FechaInicio) and convert(date,FechaFin)
		ORDER BY CreatedDate DESC



		SELECT	CONVERT(VARCHAR(20),EMS.Empleado_Ident) EMPLEADO,
				--'0' REG,
				PS.Descripcion CONCEPTO,
				--'' ACCION,
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
				END PORCENTAJE
				--'' FECHA,
				--''	SEMANA,
				--''	FECHA_INI,
				--''	FECHA_FIN,
				--''	DURACION,
				--''	FOLIO,
				--''	CONSECUENCIA,
				--''	CONTROL
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
				LEFT JOIN [app620].[CatEmployeeCCMSVw] E ON E.Ident = EMS.[Empleado_Ident]
				INNER JOIN [app620].[CatLocationVw] AS b ON E.Location_Ident = b.Location_Ident
				INNER JOIN [ITAL].[app012].[RelLocationBiosCCMSVw] LB ON LB.location_ccms = E.Location_Ident
				INNER JOIN [app620].[CatPerfilEmpleados] PE ON	ISNULL(NULLIF(PE.Country_Ident, -1), b.country_ident) = b.country_ident AND 
																ISNULL(NULLIF(PE.City_Ident, -1), LB.location_bios) = LB.location_bios AND 
																ISNULL(NULLIF(PE.Location_Ident, -1), E.Location_Ident) = E.Location_Ident AND 
																ISNULL(NULLIF(PE.Client_Ident, -1), E.Client_Ident) = E.Client_Ident AND
																ISNULL(NULLIF(PE.Program_Ident, -1),E.Program_Ident) = E.Program_Ident AND
																ISNULL(NULLIF(PE.Contract_Type_Ident, -1), E.Contract_Type_Ident) = E.Contract_Type_Ident
				--INNER JOIN [app620].[CatPerfilEmpleadosAccesos] PEA ON PE.Perfil_Ident = PEA.Perfil_Ident
				INNER JOIN [app620].[CatPeriodosNomina] PN ON PN.PeriodoNominaId = S.PeriodoNominaId
		WHERE	
				S.EstatusSolicitudId = 'CE'
				AND EMS.EstatusSolicitudId = 'CE'
				AND PE.TipoAccesoId = 3
				AND PE.Active = 1
				--AND PEA.Active = 1
				AND PN.PeriodoNominaId = @PeriodoNominaId
				--AND PEA.EmpleadoId = @EmpleadoId
				--AND E.Current_Status IN (CASE WHEN @Activos = 1 THEN 'Active'  ELSE 'Terminated' END)
				AND E.Current_Status = 'Active'
	END
GO

