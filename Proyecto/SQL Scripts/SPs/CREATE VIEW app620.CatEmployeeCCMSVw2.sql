USE [ASN2]
GO

/****** Object:  View [app620].[CatEmployeeCCMSVw2]    Script Date: 01/10/2019 05:58:51 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* VISTAS CAMBIOS */
CREATE VIEW [app620].[CatEmployeeCCMSVw2]
AS
SELECT        a.Ident, a.First_Name, a.Middle_Name, a.Last_Name, a.Manager_Ident, a.Manager_First_Name, a.Manager_Middle_Name, a.Manager_Last_Name, a.Current_Status, a.Hire_Date, a.Location_Ident, a.Location_Name, 
                         a.Client_Ident, a.Client_Name, a.Program_Ident, a.Program_Name, a.Phone_Ident, a.Account_ID, a.position_code_company_name, a.ETN_type, a.ETN, a.Company_Ident, a.Company_Name, a.Contract_Type, 
                         a.Contract_Type_Ident, a.Position_Code_Ident, a.Departament, a.Departament_Ident, a.Gender, a.email1, a.last_day_worked, a.Weekly_Hours, a.Tenure_Date, a.Birth_Date, a.Term_Date, a.Term_Reason_Type_Ident, 
                         a.Term_Reason_Type, a.Term_Reason_Ident, a.term_reason, a.Term_Status, a.Term_Voluntary, a.Term_Rehire, a.switch_desc, a.Last_Update, a.Position_Code_Title, a.position_code_type_full_name, b.country_ident, 
                         b.country_full_name, b.country_abbr_name, a.position_code_company_ident, CASE WHEN a.Middle_Name IS NULL OR
                         LEN(a.Middle_Name) = 0 THEN a.First_Name + ' ' + a.Last_Name ELSE a.First_Name + ' ' + isnull(a.Middle_Name, '') + ' ' + a.Last_Name END AS Nombre
FROM            [Mty1vacd-01].CCMS.dbo.TPNSR_CCMS_EmployeePlus AS a INNER JOIN
                         [Mty1vacd-01].CCMS.XMLRPC.LocationBuildLocation AS b ON a.Location_Ident = b.ident
WHERE        (a.Current_Status = 'Active')
GO


