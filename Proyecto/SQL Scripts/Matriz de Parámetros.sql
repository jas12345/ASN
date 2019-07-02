USE [ASN]
GO

SELECT * FROM [app620].[CatEmployeeCCMSVw]
WHERE Client_Ident = 3583


SELECT * FROM            app620.CatRelLocationBiosCCMSVw


//City
SELECT DISTINCT LocBios.location_bios AS Id, LocBios.locationname AS Value
FROM            app620.CatRelLocationBiosCCMSVw AS LocBios INNER JOIN
                         app620.CatEmployeeCCMSVw AS Emp ON Emp.Location_Ident = LocBios.location_ccms
WHERE        (Emp.Current_Status = 'Active')



SELECT    DISTINCT    
b.country_ident, b.country_full_name, --b.country_abbr_name, 
LocBios.location_bios, LocBios.locationname,
a.Location_Ident, a.Location_Name, 
a.Client_Ident, a.Client_Name, 
a.Program_Ident, a.Program_Name, 
a.Contract_Type_Ident, a.Contract_Type
----, 
--a.Departament_Ident, a.Departament, 
--a.Company_Ident, a.Company_Name, 
FROM            [Mty1vacd-01].CCMS.dbo.TPNSR_CCMS_EmployeePlus AS a INNER JOIN
                         [Mty1vacd-01].CCMS.XMLRPC.LocationBuildLocation AS b ON a.Location_Ident = b.ident
						 INNER JOIN
                         app620.CatRelLocationBiosCCMSVw AS LocBios ON LocBios.location_ccms = a.Location_Ident
WHERE        (a.Current_Status = 'Active')

