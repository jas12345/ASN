USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudesSel]    Script Date: 18/06/2019 09:24:19 a. m. ******/
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
		 Sol.[FolioSolicitud]
		,Con.ConceptoId
		,Con.Descripcion ConceptoDesc
		,ConMot.ConceptoMotivoId
		,ConMot.Descripcion ConceptoMotivoDesc
		,EMP.Ident
		,EMP.Nombre

  --    ,convert(nvarchar(10),CS.[Fecha_Solicitud],120) AS [Fecha_Solicitud]
  --    ,CS.[Perfil_Ident]
	 -- ,CPE.NombrePerfilEmpleados
  --    ,CS.CreatedBy AS Solicitante_Ident
  --    ,EMP.Nombre AS Solicintante_Nombre
  --    ,CS.[Puesto_solicitante_Ident]
  --    ,CONVERT(VARCHAR(50), CPN.NombrePeriodo) AS PeriodoNomina_Id
	 -- ,CS.[PeriodoNominaAnio_Id]
  --    ,CS.[PeriodoNominaMes_Id]
  --    ,CS.[PeriodoNominaConsecutivoid]
  --    ,CS.[PeriodoNominaPeriodicidadNomina_Id]
  --    ,CS.[PeriodoNominaTipoPeriodo_Id]
  --    ,CS.[ConceptoId]
	 -- ,CC.Descripcion AS NombreConcepto
  --    ,CS.[MotivoId]
	 -- ,CMS.Descripcion AS NombreMotivo
  --    ,CS.[Justficacion]
  --    ,CS.[Responsable_Id]
  --    ,CS.[Detalle]
	 -- ,CONVERT(VARCHAR(50), CPN2.NombrePeriodo) AS PeriodoNominaOriginal_Id
  --    ,CS.[PeriodoOriginal_AnioId]
  --    ,CS.[PeriodoOriginal_MesId]
  --    ,CS.[PeriodoOriginal_ConsecutivoId]
  --    ,CS.[PeriodoOriginal_PeriodicidadId]
  --    ,CS.[PeriodoOriginal_TipoPeriodoId]
  --    ,CS.[Autorizantes]
	 -- ,'' as ListaEmpleados
	 -- ,CS.[EstatusSolicitudId]
	 -- ,CES.Descripcion AS Estatus
  --    ,CS.[Active]


	FROM [ASN].[app620].[CatSolicitudes] Sol

	LEFT JOIN [ASN].[app620].[CatEmpleadosSolicitudes] EmpSol 
		ON empSol.FolioSolicitud = sol.FolioSolicitud

	LEFT JOIN [app620].[CatSolicitudEmpleadosDetalle] SED
		ON SED.FolioSolicitud = Empsol.FolioSolicitud
		AND SED.[Empleado_Ident] = Empsol.[Empleado_Ident]
		AND SED.[ConceptoId] = Empsol.[ConceptoId]

	LEFT JOIN app620.CatEmployeeCCMSVw EMP 
		ON EMP.Ident = EmpSol.[Empleado_Ident]

	LEFT JOIN [app620].[CatConceptos] Con
		ON Con.ConceptoId = EmpSol.ConceptoId

	----JOIN [app620].[CatPeriodosNomina] PernomSol
	----	ON PernomSol.PeriodoNominaId = Sol.PeriodoNominaId

	----JOIN [app620].[CatPeriodosNomina] PerNomSolEmpDet
	----	ON PerNomSolEmpDet.PeriodoNominaId = SED.PeriodoOriginalId

	LEFT JOIN [app620].[CatConceptosMotivos] ConMot
		ON ConMot.ConceptoMotivoId = SED.ConceptoMotivoId

	WHERE Sol.FolioSolicitud = @FolioSolicitud

 -- LEFT JOIN [app620].[CatPerfilEmpleados] CPE ON CPE.Perfil_Ident = CS.Perfil_Ident
 -- LEFT JOIN [app620].[CatConceptos] CC ON CC.ConceptoId = CS.ConceptoId
 -- LEFT JOIN [app620].[CatMotivosSolicitud] CMS ON CMS.MotivosSolicitudId = CS.MotivoId
 -- --LEFT JOIN app620.CatPeriodosNomina CPN ON CPN.AnioId = CS.PeriodoNominaAnio_Id 
	--	--		AND CPN.MesId = CS.PeriodoNominaMes_Id 
	--	--		AND CPN.ConsecutivoId = cs.PeriodoNominaConsecutivoid
	--	--		AND CPN.PeriodicidadNominaId = CS.PeriodoNominaPeriodicidadNomina_Id
	--	--		AND CPN.TipoPeriodo = CS.PeriodoNominaTipoPeriodo_Id
 -- --LEFT JOIN app620.CatPeriodosNomina CPN2 ON CPN2.AnioId = CS.PeriodoOriginal_AnioId 
	--	--		AND CPN2.MesId = CS.PeriodoOriginal_MesId 
	--	--		AND CPN2.ConsecutivoId = cs.PeriodoOriginal_ConsecutivoId
	--	--		AND CPN2.PeriodicidadNominaId = CS.PeriodoOriginal_PeriodicidadId
	--	--		AND CPN2.TipoPeriodo = CS.PeriodoOriginal_TipoPeriodoId
	--JOIN [ASN].[app620].[CatEstatusSolicitudes] CES ON CES.EstatusSolicitudId = CS.EstatusSolicitudId
 -- WHERE CS.[Active] = 1
 -- AND (CS.FolioSolicitud = @FolioSolicitud OR @FolioSolicitud = 0)

END