USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosPeopleSoftSi]    Script Date: 08/07/2019 12:28:54 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatConceptosPeopleSoftSi]
	 @Descripcion VARCHAR(50)
	,@DescripcionPeopleSoft VARCHAR(50)
	,@UserEmployeeId INT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	DECLARE
		 @FechaActual DATETIME

	-- Se inicializa @Estatus a cero si el valor de entrada es NULL
	SET @Estatus = ISNULL(@Estatus, 0)

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
	- 0 = Proceso sin error
	- -1 = Ya existe un registro con la misma descripción
	*/
	
	SET @FechaActual = GETDATE();

	IF NOT EXISTS	(
						SELECT 1 
						FROM [app620].[CatConceptosPeopleSoft] 
						WHERE [Descripcion] = @Descripcion
					)
		BEGIN
			INSERT INTO [app620].[CatConceptosPeopleSoft]
			   (
					[Descripcion]
				   ,[DescripcionPeopleSoft]
				   ,[CreatedBy]
				   ,[LastModifiedBy]
			   )
		 VALUES
				(
					 @Descripcion
					,@DescripcionPeopleSoft
					,@UserEmployeeId 
					,@UserEmployeeId 
				)
		END
	ELSE
		SET @Estatus = -1

END
