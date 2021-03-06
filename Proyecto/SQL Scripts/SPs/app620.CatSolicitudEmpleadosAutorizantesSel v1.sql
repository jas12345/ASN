USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudEmpleadosAutorizantesSel]    Script Date: 01/10/2019 04:29:05 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************/
/* Autor: Michell Cuni													 *******/
/* Descripción: Sp que retorna todos los Empleados con sus autorizadores. ******/
/*			Se utiliza para el llenado del grid del ultimo paso de solicitudes */
/*******************************************************************************/
ALTER PROC [app620].[CatSolicitudEmpleadosAutorizantesSel]
@FolioSolicitud INT
AS
BEGIN
	SELECT DISTINCT CSED.[FolioSolicitud]
      ,CSED.[Empleado_Ident]
      ,CSEA.[Autorizador_Ident]
	  ,CEVWEM.Nombre AS NombreEmpleado
	  ,CONCAT(CAST(CEVWRES.Ident AS VARCHAR(10)),' - ',CEVWRES.Nombre, ' - ', CEVWRES.Position_Code_Title) AS NombreAutorizador
      ,CSEA.[NivelAutorizacion]
      ,(CASE
			WHEN CSEA.[Obligatorio] = 1 THEN 'Si' ELSE 'No' END) AS EsObligatorio
	  ,CSEA.[Obligatorio]
      ,CSEA.[MontoAutorizacionAutomatica]
	  ,(CASE
			WHEN CSEA.[Autorizado] = 1 THEN 'AUTORIZADO'
			WHEN CSEA.[Rechazado] = 1 THEN 'RECHAZADO'
			WHEN CSEA.[Cancelado] = 1 THEN 'CANCELADO'
			END
	  ) AS Estatus
	  ,CEVWEM.Contract_Type AS Contrato
	  ,CEVWRES.email1 AS EmailManager
      ,CSEA.[Autorizado]
      ,CSEA.[Rechazado]
      ,CSEA.[Cancelado]
	  ,CS.[Perfil_Ident] AS Perfil
      ,CSEA.[Active]
  FROM [app620].CatEmpleadosSolicitudes CSED
  JOIN [app620].[CatSolicitudes] CS ON CS.FolioSolicitud = CSED.FolioSolicitud
  LEFT JOIN  [app620].[CatSolicitudEmpleadosAutorizantes] CSEA ON CSEA.Empleado_Ident = CSED.Empleado_Ident
  LEFT JOIN [app620].[CatEmployeeCCMSVw] CEVWEM on CEVWEM.Ident = CSED.Empleado_Ident
  LEFT JOIN [app620].[CatEmployeeCCMSVw] CEVWRES on CEVWRES.Ident = CSEA.Autorizador_Ident
  WHERE CSED.FolioSolicitud = @FolioSolicitud AND CSED.Active=1
END
