USE [ASN_PE]
GO
/****** Object:  StoredProcedure [app620].[CatContractTypeByProgramCMB]    Script Date: 27/06/2020 10:04:05 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[CatContractTypeByProgramCMB]
		 @Country INT = NULL
		,@CityId INT = NULL
		,@SiteId INT = NULL
		,@ClientId VARCHAR(1000) = NULL
		,@ProgramId INT = NULL		
		--,@CrontactId INT = NULL
AS
BEGIN
	SET @Country = NULLIF(NULLIF(@Country,0),-1)
	SET @CityId = NULLIF(NULLIF(@CityId,0),-1)
	SET @SiteId = NULLIF(NULLIF(@SiteId,0),-1)
	SET @ClientId = NULLIF(NULLIF(@ClientId,0),-1)
	SET @ProgramId = NULLIF(NULLIF(@ProgramId,0),-1)
	--SET @CrontactId = NULLIF(NULLIF(@CrontactId,0),-1)

	SELECT	DISTINCT
			 [Contract_Type_Ident] As Id
			,[Contract_Type] As Value
	FROM	app620.CatEmployeeCCMSVw Emp WITH(NOLOCK)
	JOIN [app620].[RelLocationBiosCCMSVw] LocBios WITH(NOLOCK) ON 
				emp.Location_Ident = LocBios.location_ccms
			AND
			(
				LocBios.location_bios	= ISNULL(@CityId, LocBios.location_bios)	
			OR 
				@CityId	= -1
			)
	WHERE	
			Emp.country_ident		= ISNULL(@Country, Emp.country_ident) AND
			Location_Ident			= ISNULL(@SiteId,Location_Ident) AND 
			(Emp.Client_Ident		IN (SELECT item Client_Ident FROM fnSplit(@ClientId, ',')) OR @ClientId = -1) AND
			Program_Ident			= ISNULL(@ProgramId,Program_Ident)
			--Client_Ident			= ISNULL(@ClientId,Client_Ident) 
			--AND Contract_Type_Ident = ISNULL(@CrontactId,Contract_Type_Ident)
	UNION
	SELECT
		 -1 AS Id
		,'- Todos -' AS Value
END