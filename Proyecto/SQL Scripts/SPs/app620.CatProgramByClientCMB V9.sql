USE [ASN_PE_Dev]
GO
/****** Object:  StoredProcedure [app620].[CatProgramByClientCMB]    Script Date: 29/06/2020 12:30:01 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatProgramByClientCMB]
		 @Country INT = NULL
		,@CityId INT = NULL
		,@SiteId INT = NULL
		,@ClientId VARCHAR(1000) = NULL
		--,@ProgramId INT = NULL
		--,@CrontactId INT = NULL
AS
BEGIN

	SET @Country = ISNULL(NULLIF(@Country,0),-1)
	SET @CityId = ISNULL(NULLIF(@CityId,0),-1)
	SET @SiteId = ISNULL(NULLIF(@SiteId,0),-1)
	--SET @ClientId = NULLIF(NULLIF(@ClientId,0),'-1')
	--SET @ProgramId = NULLIF(NULLIF(@ProgramId,0),-1)
	--SET @CrontactId = NULLIF(NULLIF(@CrontactId,0),-1)

	SELECT	DISTINCT
			 [Program_Ident] As Id
			,[Program_Name] As Value
	FROM	app620.CatEmployeeCCMSAllVw Emp
	JOIN [app620].[CatRelLocationBiosCCMSVw] LocBios ON
			LocBios.location_ccms  = Emp.Location_Ident AND
		(
			LocBios.location_bios	= ISNULL(@CityId, LocBios.location_bios)	
		OR 
			@CityId	= -1
		)

	WHERE	
		(Emp.country_ident		= ISNULL(@Country, Emp.country_ident)		OR @Country	= -1) 
	AND
		(Emp.Location_Ident		= ISNULL(@SiteId, Emp.Location_Ident)		OR @SiteId	= -1) 
	AND 
		(Emp.Client_Ident		IN (SELECT item Client_Ident FROM fnSplit(@ClientId, ',')) OR @ClientId = '-1')
	UNION
	SELECT
		 -1 AS Id
		,'- Todos -' AS Value
	ORDER BY Value
END