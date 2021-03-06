USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatEmpleadosSolicitudesSel]    Script Date: 27/06/2019 07:11:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatEmpleadosSolicitudesSel]
@FolioSolicitud INT = 0
AS
BEGIN

IF @FolioSolicitud=0
BEGIN
	SELECT CES.[FolioSolicitud]
			  ,CES.[Empleado_Ident]
			  ,CES.[Empleado_First_Name]
			  ,CES.[Empleado_Middle_Name]
			  ,CES.[Empleado_Last_Name]
			  ,CES.[Empleado_Position_Code_Ident]
			  ,CES.[Empleado_Position_Code_Title]
			  ,CES.[Empleado_Contract_Type_Ident]
			  ,CES.[Empleado_Contract_Type]
			  ,CES.[Manager_Ident]
			  ,CONCAT(CES.[Manager_First_Name], ' ',Manager_Middle_Name,' ',Manager_Last_Name) AS Manager_First_Name
			  ,CES.[Manager_Middle_Name]
			  ,CES.[Manager_Last_Name]
			  ,CES.[Manager_Position_Code_Ident]
			  ,CES.[Manager_Position_Code_Title]
			  ,CES.[Manager_Contract_Type_Ident]
			  ,CES.[Manager_Contract_Type]
			  ,CAST(CSED.CatConceptoMotivoId as VARCHAR(50)) AS CatConceptoMotivoId
			  ,CES.ParametroConceptoMonto AS ParametroConceptoMonto
			  ,CCM.Descripcion AS ConceptoMotivo
			  ,CES.Detalle AS Detalle
			  ,(CASE WHEN CPN.NombrePeriodo IS NULL THEN '' ELSE CPN.NombrePeriodo END) AS PeriodoNomina
			  ,CES.[Active]     
		  FROM [app620].[CatEmpleadosSolicitudes] CES
		  LEFT JOIN [app620].[CatSolicitudEmpleadosDetalle] CSED ON CSED.FolioSolicitud = CES.FolioSolicitud 
					AND CSED.Empleado_Ident = CES.Empleado_Ident
			LEFT JOIN [app620].[CatConceptosMotivos] CCM ON CCM.ConceptoMotivoId = CSED.CatConceptoMotivoId
			LEFT JOIN app620.CatPeriodosNomina CPN ON CPN.AnioId = CSED.PeriodoOriginalAnio_Id
				 AND CPN.MesId = CSED.PeriodoOriginalMes_Id
				 AND CPN.ConsecutivoId = CSED.PeriodoOriginalConsecutivoid
				 AND CPN.PeriodicidadNominaId = CSED.PeriodoOriginalPeriodicidadNomina_Id
				 AND CPN.TipoPeriodo = CSED.PeriodoOriginalTipoPeriodo_Id
		  WHERE CES.[Active] = 1
  END
  ELSE
	BEGIN
		SELECT CES.[FolioSolicitud]
			  ,CES.[Empleado_Ident]
			  ,CES.[Empleado_First_Name]
			  ,CES.[Empleado_Middle_Name]
			  ,CES.[Empleado_Last_Name]
			  ,CES.[Empleado_Position_Code_Ident]
			  ,CES.[Empleado_Position_Code_Title]
			  ,CES.[Empleado_Contract_Type_Ident]
			  ,CES.[Empleado_Contract_Type]
			  ,CES.[Manager_Ident]
			  ,CONCAT(CES.[Manager_First_Name], ' ',Manager_Middle_Name,' ',Manager_Last_Name) AS Manager_First_Name
			  ,CES.[Manager_Middle_Name]
			  ,CES.[Manager_Last_Name]
			  ,CES.[Manager_Position_Code_Ident]
			  ,CES.[Manager_Position_Code_Title]
			  ,CES.[Manager_Contract_Type_Ident]
			  ,CES.[Manager_Contract_Type]
			  ,CAST(CSED.CatConceptoMotivoId as VARCHAR(50)) AS CatConceptoMotivoId--,CSED.CatConceptoMotivoId AS CatConceptoMotivoId
			  ,CCM.Descripcion AS ConceptoMotivo
			  ,CES.ParametroConceptoMonto AS ParametroConceptoMonto
			  ,CES.Detalle AS Detalle
			  ,(CASE WHEN CPN.NombrePeriodo IS NULL THEN '' ELSE CPN.NombrePeriodo END) AS PeriodoNomina
			  ,CES.[Active]     
		  FROM [app620].[CatEmpleadosSolicitudes] CES
		  LEFT JOIN [app620].[CatSolicitudEmpleadosDetalle] CSED ON CSED.FolioSolicitud = CES.FolioSolicitud 
					AND CSED.Empleado_Ident = CES.Empleado_Ident AND CSED.Active = 1
		  LEFT JOIN [app620].[CatConceptosMotivos] CCM ON CCM.ConceptoMotivoId = CSED.CatConceptoMotivoId
		  LEFT JOIN app620.CatPeriodosNomina CPN ON CPN.AnioId = CSED.[PeriodoOriginalAnio_Id]
				 AND CPN.MesId = CSED.[PeriodoOriginalMes_Id]
				 AND CPN.ConsecutivoId = CSED.[PeriodoOriginalConsecutivoid]
				 AND CPN.PeriodicidadNominaId = CSED.[PeriodoOriginalPeriodicidadNomina_Id]
				 AND CPN.TipoPeriodo = CSED.[PeriodoOriginalTipoPeriodo_Id]
		  WHERE CES.[Active] = 1 AND CES.FolioSolicitud =@FolioSolicitud
	END
END
