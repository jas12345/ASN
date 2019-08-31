ALTER PROC [app620].[CatLocationByCityCMB]
		@CityId INT = NULL
		--@Country INT = NULL,
		--,@SiteId INT = NULL
		--,@ClientId INT = NULL
		--,@ProgramId INT = NULL
		--,@CrontactId INT = NULL
AS
BEGIN
	--SET @Country = NULLIF(NULLIF(@Country,0),-1)
	SET @CityId = NULLIF(NULLIF(@CityId,0),-1)
	--SET @SiteId = NULLIF(NULLIF(@SiteId,0),-1)
	--SET @ClientId = NULLIF(NULLIF(@ClientId,0),-1)
	--SET @ProgramId = NULLIF(NULLIF(@ProgramId,0),-1)
	--SET @CrontactId = NULLIF(NULLIF(@CrontactId,0),-1)

	SELECT	DISTINCT Emp.Location_Ident As Id, 
			Emp.Location_Name As Value
	FROM	[ITAL].[app012].[RelLocationBiosCCMSVw] LocBios
			JOIN [app620].[CatEmployeeCCMSVw] Emp ON emp.Location_Ident = LocBios.location_ccms
	WHERE	LocBios.location_bios = ISNULL(@CityId,LocBios.location_bios)
			--AND Emp.country_ident = ISNULL(@Country,Emp.country_ident)			
			--AND Program_Ident = ISNULL(@ProgramId,Program_Ident)
			--AND Client_Ident = ISNULL(@ClientId,Client_Ident)
			--AND Location_Ident = ISNULL(@SiteId,Location_Ident)
			--AND Contract_Type_Ident = ISNULL(@CrontactId,Contract_Type_Ident)
	UNION
	SELECT
		 -1 AS Id
		,'- Todos -' AS Value
END
GO


