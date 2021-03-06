USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatEmpleadosSolicitudesSel]    Script Date: 14/06/2019 11:33:48 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatEmpleadosSolicitudesSel]
@FolioSolicitud INT = 0
AS
BEGIN
	SET @FolioSolicitud = ISNULL(@FolioSolicitud, 0)

	BEGIN
		SET @FolioSolicitud = ISNULL(@FolioSolicitud, 0)

		SELECT CES.[FolioSolicitud]
					,CES.[Empleado_Ident]
					--,CES.s
					,CAST(CSED.ConceptoMotivoId as VARCHAR(50)) AS CatConceptoMotivoId
					,CES.ParametroConceptoMonto AS ParametroConceptoMonto
					,CCM.Descripcion AS ConceptoMotivo
					--,CES.Detalle AS Detalle
					,ISNULL(CPN.NombrePeriodo, '') AS PeriodoNomina
					,CES.[Active]     
				FROM [app620].[CatEmpleadosSolicitudes] CES
				JOIN [app620].[CatSolicitudEmpleadosDetalle] CSED 
					ON CSED.FolioSolicitud = CES.FolioSolicitud 
					AND CSED.Empleado_Ident = CES.Empleado_Ident
					AND CSED.ConceptoId = CES.ConceptoId
				LEFT JOIN app620.CatPeriodosNomina CPN 
					ON CPN.PeriodoNominaId = CSED.PeriodoOriginalId
				LEFT JOIN [app620].[CatConceptosMotivos] CCM 
				ON CCM.ConceptoMotivoId = CSED.ConceptoMotivoId
				WHERE CES.[Active] = 1
				AND CSED.Active = 1
				AND (CES.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)
	END
END
