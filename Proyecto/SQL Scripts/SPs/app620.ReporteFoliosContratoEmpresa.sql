----------------------------------------------------------------------
-- Author:      José Alfredo Saldaña Resendez	
-- Create date: 13/Julio/2020
-- Description: SP para separar el Contrato/Empresa de cada folio
----------------------------------------------------------------------
USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[ReporteFoliosContratoEmpresaSel]    Script Date: 13/07/2020 09:51:00 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[ReporteFoliosContratoEmpresa]
@PeriodoNomina int = NULL
AS
BEGIN
	
	--declare @PeriodoNomina int= 39;
	SELECT 		sol.FolioSolicitud	as Folio,  
				emp.Company_Name	as Compañia, 
				emp.Contract_Type	as Contrato,				
				count(*)		    as Total
	FROM 		app620.CatSolicitudes						sol		with (nolock)
	INNER JOIN	[app620].[CatEmpleadosSolicitudes]			empsol	with (nolock)
			ON  sol.FolioSolicitud = empsol.FolioSolicitud
	INNER JOIN	ccms.[dbo].[TPNSR_CCMS_EmployeePlus]		emp		with (nolock)
			ON  empsol.Empleado_Ident =  emp.Ident
	WHERE		periodonominaid = @PeriodoNomina 
	GROUP BY	sol.FolioSolicitud, emp.Company_Name, emp.Contract_Type
	ORDER BY	folio
	
END
-------   PRUEBAS ----------------------------------
-- EXEC [app620].[ReporteFoliosContratoEmpresaSel] 39
