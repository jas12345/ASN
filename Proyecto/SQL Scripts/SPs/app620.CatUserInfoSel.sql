USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatUserInfoSel]    Script Date: 17/04/2019 04:20:22 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
--*Objeto:				[CatUserInfoSel]
--*Autor:				Javier Raygoza
--*Fecha de creación:	Enero 09, 2017
--*Objetivo:			Obtiene la informacion del empleado
--*Entrada:				NA
--*Salida:				NA
--*Precondiciones:		NA
--*Retorno:				NA
--*Revisiones:		
--*Movimiento - /XXX - Fecha del Movimiento 
-- [app601].[CatUserInfoSel] 844795
-- =============================================
ALTER PROC [app620].[CatUserInfoSel]
(
	@CCMSID int = 0
)
AS
BEGIN
	
	--supplying a data contract
	IF 1 = 2 BEGIN
		SELECT
			cast(null as int)				as Ident
			,cast(null as nvarchar(MAX))    as First_Name
			,cast(null as nvarchar(MAX))    as Middle_Name
			,cast(null as nvarchar(MAX))    as Last_Name
			,cast(null as int)				as Manager_Ident
			,cast(null as nvarchar(MAX))    as Manager_First_Name
			,cast(null as nvarchar(MAX))    as Manager_Middle_Name
			,cast(null as nvarchar(MAX))    as Manager_Last_Name
			,cast(null as datetime)			as Hire_Date
			,cast(null as nvarchar(MAX))    as Position_Code_Title
			,cast(null as int)				as Location_Ident
			,cast(null as nvarchar(MAX))    as Location_Name
			,cast(null as int)				as Contract_Type_Ident
			,cast(null as nvarchar(MAX))    as Contract_Type
			,cast(null as nvarchar(MAX))    as Account_ID
			,cast(null as int)				as Country_ident
			,cast(null as nvarchar(MAX))	as FullName
			--,cast(null as int)				as CountryIdBIOS
			--,cast(null as int)				as CityIdBIOS
		WHERE
			1 = 2  
	END

	SELECT 
		a.ident 
		,a.First_Name
		,a.Middle_Name
		,a.Last_Name
		,a.Manager_Ident
		,a.Manager_First_Name
		,a.Manager_Middle_Name
		,a.Manager_Last_Name
		,a.Hire_Date
		,a.Position_Code_Title
		,a.Location_Ident
		,a.Location_Name
		,a.Contract_Type_Ident
	,a.Contract_Type
		,a.Account_ID
		,a.[country_ident]
		,CASE WHEN a.Middle_Name IS NULL OR LEN(a.Middle_Name) = 0 THEN a.First_Name + ' ' + a.Last_Name ELSE a.First_Name + ' ' + isnull(a.Middle_Name,'') + ' ' + a.Last_Name END AS FullName
		--,b.CountryId as CountryIdBIOS
		--,b.CityId As CityIdBIOS
	FROM [app620].CatEmployeeCCMSVw a
	--INNER JOIN [app591].[CatRelLocationCityVw] b on a.Location_Ident = b.LocationId
	WHERE Ident = @CCMSID
END






