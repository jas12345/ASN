USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudesSel]    Script Date: 09/05/2019 04:53:34 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatSolicitudesSel]
@FolioSolicitud INT = 0
AS
BEGIN

	SET @FolioSolicitud = ISNULL(@FolioSolicitud, 0)

	SELECT
		CS.[FolioSolicitud]
      ,convert(nvarchar(10),CS.[Fecha_Solicitud],120) AS [Fecha_Solicitud]
      ,CS.[Perfil_Ident]
	  ,CPE.NombrePerfilEmpleados
      ,CS.CreatedBy AS Solicitante_Ident
      ,EMP.Nombre AS Solicintante_Nombre
      ,CS.[Puesto_solicitante_Ident]
      ,CONVERT(VARCHAR(50), CPN.NombrePeriodo) AS PeriodoNomina_Id
	  ,CS.[PeriodoNominaAnio_Id]
      ,CS.[PeriodoNominaMes_Id]
      ,CS.[PeriodoNominaConsecutivoid]
      ,CS.[PeriodoNominaPeriodicidadNomina_Id]
      ,CS.[PeriodoNominaTipoPeriodo_Id]
      ,CS.[ConceptoId]
	  ,CC.Descripcion AS NombreConcepto
      ,CS.[MotivoId]
	  ,CMS.Descripcion AS NombreMotivo
      ,CS.[Justficacion]
      ,CS.[Responsable_Id]
      ,CS.[Detalle]
	  ,CONVERT(VARCHAR(50), CPN2.NombrePeriodo) AS PeriodoNominaOriginal_Id
      ,CS.[PeriodoOriginal_AnioId]
      ,CS.[PeriodoOriginal_MesId]
      ,CS.[PeriodoOriginal_ConsecutivoId]
      ,CS.[PeriodoOriginal_PeriodicidadId]
      ,CS.[PeriodoOriginal_TipoPeriodoId]
      ,CS.[Autorizantes]
	  ,'' as ListaEmpleados
      ,CS.[Active]
  FROM [ASN].[app620].[CatSolicitudes] CS
  LEFT JOIN [app620].[CatPerfilEmpleados] CPE ON CPE.Perfil_Ident = CS.Perfil_Ident
  LEFT JOIN [app620].[CatConceptos] CC ON CC.ConceptoId = CS.ConceptoId
  LEFT JOIN [app620].[CatMotivosSolicitud] CMS ON CMS.MotivosSolicitudId = CS.MotivoId
  LEFT JOIN app620.CatPeriodosNomina CPN ON CPN.AnioId = CS.PeriodoNominaAnio_Id 
				AND CPN.MesId = CS.PeriodoNominaMes_Id 
				AND CPN.ConsecutivoId = cs.PeriodoNominaConsecutivoid
				AND CPN.PeriodicidadNominaId = CS.PeriodoNominaPeriodicidadNomina_Id
				AND CPN.TipoPeriodo = CS.PeriodoNominaTipoPeriodo_Id
  LEFT JOIN app620.CatPeriodosNomina CPN2 ON CPN2.AnioId = CS.PeriodoOriginal_AnioId 
				AND CPN2.MesId = CS.PeriodoOriginal_MesId 
				AND CPN2.ConsecutivoId = cs.PeriodoOriginal_ConsecutivoId
				AND CPN2.PeriodicidadNominaId = CS.PeriodoOriginal_PeriodicidadId
				AND CPN2.TipoPeriodo = CS.PeriodoOriginal_TipoPeriodoId
	JOIN app620.CatEmployeeCCMSVw EMP ON EMP.Ident = CS.CreatedBy
  WHERE CS.[Active] = 1
  AND (CS.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

END