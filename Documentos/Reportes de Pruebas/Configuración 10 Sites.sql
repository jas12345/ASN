USE ASN3;
GO

--SELECT Top 11 Ident,Account_ID,Nombre,Contract_Type,Client_Name,Location_Name
SELECT Top 110 Ident Id,Account_ID Acc,Nombre Nom,Contract_Type CT,Client_Name CN,Location_Name LN, *
FROM [app620].[CatEmployeeCCMSVw]
WHERE 
--	Contract_Type_Ident	= 830
--AND Client_Ident			= 882
--AND Location_Ident			= 320
--AND 
	Current_Status			='active'
--AND position_code_title		like '%agent%'
--AND 
--	position_code_title		NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic') -- Solicitantes / Autorizadores
AND 
	Position_Code_Title IN ('IMSS Coordinator', 'IMSS Manager', 'Payroll Coordinator', 'Payroll Manager', 'Payroll Specialist', 'Payroll Sr. Manager')	-- Responsables
AND
	country_ident = 239
--ORDER BY Contract_Type,Client_Name,Location_Name
ORDER BY Ident DESC

--(No column name)	Contract_Type_Ident		Client_Ident	Location_Ident
--OK 517				831						595				318		HT		- Comcast		- TPMXN Cuervo

--OK 486				830						882				320		HTG		- Alliance Data	- TPMXN Nova
--OK 523				1120					313				530		HTG PUE	- Western Union	- TPMXN Talavera
--OK 604				1118					4062			210		HTG HMO	- GrubHub		- TPMXN Saguaro
--OK 671				1119					595				496		HTG AGU - Comcast		- TPMXN Hacienda
--OK 871				1580					1787			315		HTG MTY - GM Financial	- TPMXN Universidad
--OK 977				1579					4138			545		HTG MXD - Chime Bank	- TPMXN Zentralia
--OK 1022				1579					1427			312		HTG MXD - Banamex-CITI	- TPMXD Toreo
--OK 1380				830						595				180		HTG		- Comcast		- TPMXN Alpha
--OK 456				1579					313				876		HTG MXD	- Western Union	- TPMXN Sierra
--OK 406				1580					4138			317		HTG MTY - Chime Bank	- TPMXN Cuauhtemoc

--381					548						3278			649
--400					804						338				482
--405					548						3215			457
--410					548						1566			298
--413					804						261				819
--489					548						2079			532
--493					548						2079			532
--621					548						338				298

SELECT TOP 10 *
FROM [app620].[CatEmployeeCCMSVw]
WHERE Account_ID = 'cavazosdiaz.5'


SELECT *
FROM app620.CatPerfilEmpleados



SELECT COUNT (1), Contract_Type_Ident, Client_Ident, Location_Ident
FROM [app620].[CatEmployeeCCMSVw]
WHERE 
	Current_Status			='active'
AND 
	position_code_title		like '%agent%'
--AND 
--	Contract_Type_Ident	= 831
--AND 
--	Client_Ident			= 595
--AND 
--	Location_Ident			= 318
GROUP BY
	  Contract_Type_Ident
	, Client_Ident
	, Location_Ident
HAVING
	COUNT (1) > 300
ORDER BY
	COUNT (1)



exec [app620].[CatEmpleadoPuestoSel] @Ident=2194802,@Solicitante_Ident=666484
go
exec [app620].[CatEmpleadoPuestoSel] @Ident=2724943,@Solicitante_Ident=666484
go
exec [app620].[CatConceptosxEmpleadoxSolicitanteCMB] @Ident=2194802,@Ident_Solicitante=666484
go
SELECT * FROM app620.CatRelLocationBiosCCMSVw

SELECT * FROM 
app620.CatPerfilEmpleadosAccesos PEA							--Sección que conecta con los Perfiles asociados a permisos del solicitante
WHERE		PEA.EmpleadoId					= 666484

SELECT * FROM app620.CatPerfilEmpleados




