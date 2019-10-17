ALTER PROC [app620].[CatPerfilEmpleadosSi]
	 @NombrePerfilEmpleados VARCHAR(50)
	,@Country_Ident INT
	,@City_Ident INT
	,@Location_Ident INT
	,@Client_Ident INT
	,@Program_Ident INT
	,@Contract_Type_Ident INT
	,@ConceptoId VARCHAR(1500)
	,@TipoAccesoId INT

	,@UserEmployeeId INT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	DECLARE
		 @FechaActual DATETIME,
		 @Perfil_Ident INT

	-- Se inicializa @Estatus a cero si el valor de entrada es NULL
	SET @Estatus = ISNULL(@Estatus, 0)

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
	- 0 = Proceso sin error
	- -1 = Ya existe un registro con la misma descripción
	*/
	
	SET @FechaActual = GETDATE();

	SET @City_Ident = IIF(@City_Ident=0, -1, @City_Ident)


	SELECT *
	FROM [app620].[CatPerfilEmpleados] 
	WHERE [NombrePerfilEmpleados] = @NombrePerfilEmpleados


	IF NOT EXISTS	
			(
				SELECT 1
				FROM [app620].[CatPerfilEmpleados] 
				WHERE [NombrePerfilEmpleados] = @NombrePerfilEmpleados
			)

		BEGIN
			DECLARE @inserted TABLE (
				[Perfil_Ident] [int]
			)

			INSERT INTO [app620].[CatPerfilEmpleados]
			   (
					[NombrePerfilEmpleados]
				   ,[Country_Ident]
				   ,[City_Ident]
				   ,[Location_Ident]
				   ,[Client_Ident]
				   ,[Program_Ident]
				   ,[Contract_Type_Ident]
				   ,ConceptoId 
				   ,TipoAccesoId 

				   ,[CreatedBy]
				   ,[LastModifiedBy]
			   )
		OUTPUT Inserted.Perfil_Ident INTO @inserted
		 VALUES
				(
					 @NombrePerfilEmpleados
					,@Country_Ident
					,@City_Ident
					,@Location_Ident
					,@Client_Ident
					,@Program_Ident
					,@Contract_Type_Ident
					,NULL --@ConceptoId
					,@TipoAccesoId

					,@UserEmployeeId 
					,@UserEmployeeId 
				)

		SELECT	TOP 1 @Perfil_Ident = Perfil_Ident
		FROM @inserted;
		
		--Se insertan todos los registros de relación en CatPerfilesConceptos
		INSERT INTO app620.RelPerfilEmpleadosConceptos 
		SELECT @Perfil_Ident Perfil_Ident, Con.item ConceptoId
		FROM fnSplit(@ConceptoId,',') Con
		
		--DECLARE @script VARCHAR(200) = 'INSERT INTO app620.RelPerfilEmpleadosConceptos SELECT ' + CONVERT(VARCHAR(50),@Perfil_Ident) + ', ConceptoId FROM app620.CatConceptos WHERE	ConceptoId IN (' + @ConceptoId + ')'

		--exec(@script)


		END		
	ELSE
		SET @Estatus = -1

END
GO

