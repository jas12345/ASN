USE [ASN_PE]
GO
/****** Object:  StoredProcedure [app620].[CatClientBySiteCMB]    Script Date: 10/06/2020 11:07:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[CatClientBySiteCMB]
		@Country INT = NULL
		,@CityId INT = NULL
		,@SiteId INT = NULL
		--,@ClientId INT = NULL
		--,@ProgramId INT = NULL
		--,@CrontactId INT = NULL
AS
BEGIN
	SET @SiteId = NULLIF(NULLIF(@SiteId,0),-1)
	SET @Country = NULLIF(NULLIF(@Country,0),-1)
	SET @CityId = NULLIF(NULLIF(@CityId,0),-1)
	--SET @ClientId = NULLIF(NULLIF(@ClientId,0),-1)
	--SET @ProgramId = NULLIF(NULLIF(@ProgramId,0),-1)
	--SET @CrontactId = NULLIF(NULLIF(@CrontactId,0),-1)

	SELECT	DISTINCT
			[Client_Ident] As Ident
			,[Client_Name] As Valor
	FROM	app620.CatEmployeeCCMSVw Emp WITH(NOLOCK)
			JOIN [ITAL].[app012].[RelLocationBiosCCMSVw] LocBios WITH(NOLOCK) ON emp.Location_Ident = LocBios.location_ccms
	WHERE	Location_Ident = ISNULL(@SiteId,Location_Ident)
			AND Emp.country_ident = ISNULL(@Country, Emp.country_ident)
			AND LocBios.location_bios = ISNULL(@CityId,LocBios.location_bios)
			--AND Program_Ident = ISNULL(@ProgramId,Program_Ident)
			--AND Client_Ident = ISNULL(@ClientId,Client_Ident)
			--AND Contract_Type_Ident = ISNULL(@CrontactId,Contract_Type_Ident)
	UNION
	SELECT
		 -1 AS Ident
		,'- Todos -' AS Valor
END