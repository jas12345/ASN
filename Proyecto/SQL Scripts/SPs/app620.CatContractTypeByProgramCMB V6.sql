USE [ASN_PE]
GO
/****** Object:  StoredProcedure [app620].[CatContractTypeByProgramCMB]    Script Date: 28/06/2020 04:15:26 p. m. ******/
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
	SET @Country	= ISNULL(@Country,-1)
	SET @CityId		= ISNULL(@CityId,-1)
	SET @SiteId		= ISNULL(@SiteId,-1)
	SET @ClientId	= ISNULL(@ClientId,'-1')
	SET @ProgramId	= ISNULL(@ProgramId,-1)
	--SET @CrontactId = NULLIF(NULLIF(@CrontactId,0),-1)

	SELECT	DISTINCT
			 [Contract_Type_Ident] As Id
			,[Contract_Type] As Value
	FROM	app620.CatEmployeeCCMSVw Emp
	JOIN [app620].[CatRelLocationBiosCCMSVw] LocBios ON 
				LocBios.location_ccms = Emp.Location_Ident
			AND
			(
				LocBios.location_bios	= ISNULL(@CityId, LocBios.location_bios)	
			OR 
				@CityId	= -1
			)
	WHERE	
			(Emp.country_ident		= @Country		OR @Country = -1) AND
			(Emp.Location_Ident		= @SiteId		OR @SiteId = -1) AND 
			(Emp.Client_Ident		IN (SELECT item Client_Ident FROM fnSplit(@ClientId, ',')) OR @ClientId = '-1') AND
			(Emp.Program_Ident		= @ProgramId	OR @ProgramId = -1)
			--AND Contract_Type_Ident = ISNULL(@CrontactId,Contract_Type_Ident)
	UNION
	SELECT
		 -1 AS Id
		,'- Todos -' AS Value
END