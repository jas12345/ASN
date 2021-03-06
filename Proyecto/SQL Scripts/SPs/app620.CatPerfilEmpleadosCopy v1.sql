USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosCopy]    Script Date: 20/01/2020 01:06:47 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[CatPerfilEmpleadosCopy]
	 @Perfil_Ident INT = 0 
	,@NombrePerfilEmpleados VARCHAR (50)

	,@UserEmployeeId INT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	DECLARE
		 @FechaActual		DATETIME
		,@Perfil_Ident_INS	INT

		SET @FechaActual = GETDATE();

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
	- 0 = Proceso sin error
	- -1 = Ya existe un registro con la misma descripción
	*/
	
	SET @Perfil_Ident = ISNULL(@Perfil_Ident, 0)

	--SELECT
	--	 Perfil.[Perfil_Ident]
	--	,[NombrePerfilEmpleados] + '_Copia' AS NombrePerfilEmpleados
	--	,Perfil.[Country_Ident]
	--	,Perfil.[Location_Ident]
	--	,Perfil.[Client_Ident]
	--	,Perfil.[Program_Ident]
	--	,Perfil.[Contract_Type_Ident]
	--	,Perfil.TipoAccesoId
	--	,Perfil.Active
	--FROM [app620].[CatPerfilEmpleados] Perfil
	--WHERE (Perfil.Perfil_Ident =@Perfil_Ident)

	IF EXISTS		(
						SELECT 1 
						FROM [app620].[CatPerfilEmpleados] 
						WHERE [Perfil_Ident] = @Perfil_Ident
					)
	AND NOT EXISTS	(
						SELECT 1 
						FROM [app620].[CatPerfilEmpleados] 
						WHERE	Perfil_Ident			<> @Perfil_Ident 
						AND		NombrePerfilEmpleados	= @NombrePerfilEmpleados + '_Copia'
					)
		BEGIN
			DECLARE @inserted TABLE (
				[Perfil_Ident] [int]
			)

			INSERT INTO [app620].[CatPerfilEmpleados]
			OUTPUT Inserted.Perfil_Ident INTO @inserted
			SELECT 
				-- Perfil_Ident_INS	[Perfil_Ident]
				--,
				 @NombrePerfilEmpleados + '_Copia'	NombrePerfilEmpleados

				,[Country_Ident]			
				,[City_Ident]				
				,[Location_Ident]			
				,[Client_Ident]				
				,[Program_Ident]			
				,[Contract_Type_Ident]		
				,[ConceptoId]				
				,[TipoAccesoId]				

				,1									Active
				,@UserEmployeeId					CreatedBy
				,@FechaActual						CreatedDate
				,NULL								DeactivatedDate			
				,NULL								DeactivatedBy				
				,@UserEmployeeId					LastModifiedBy				
				,@FechaActual						LastModifiedDate			
				,HOST_NAME()						LastModifiedFromPCName					

			FROM [app620].[CatPerfilEmpleados]
			WHERE
				Perfil_Ident = @Perfil_Ident				

			--SELECT Inserted.Perfil_Ident Perfil_Ident
			SELECT	TOP 1 @Perfil_Ident_INS = Perfil_Ident
			FROM @inserted;

			--SELECT 
			--	 @Perfil_Ident_INS					[Perfil_Ident]
			--	,NombrePerfilEmpleados + '_Copia'	NombrePerfilEmpleados

			--	,[Country_Ident]			
			--	,[City_Ident]				
			--	,[Location_Ident]			
			--	,[Client_Ident]				
			--	,[Program_Ident]			
			--	,[Contract_Type_Ident]		
			--	,[ConceptoId]				
			--	,[TipoAccesoId]				

			--	,Active
			--	,CreatedBy
			--	,CreatedDate
			--	,NULL								DeactivatedDate			
			--	,NULL								DeactivatedBy				
			--	,LastModifiedBy				
			--	,LastModifiedDate			
			--	,LastModifiedFromPCName					

			--FROM [app620].[CatPerfilEmpleados]
			--WHERE
			--	Perfil_Ident = @Perfil_Ident_INS				

		--Se insertan todos los registros de relación en RelPerfilEmpleadosConceptos
		INSERT INTO app620.RelPerfilEmpleadosConceptos 
		SELECT
			 @Perfil_Ident_INS					[Perfil_Ident]
			,[ConceptoId]
		FROM app620.RelPerfilEmpleadosConceptos RPEC
		WHERE RPEC.Perfil_Ident = @Perfil_Ident

		--SELECT *
		--FROM app620.RelPerfilEmpleadosConceptos RPEC
		--WHERE RPEC.Perfil_Ident = @Perfil_Ident_INS

		INSERT INTO app620.CatPerfilEmpleadosAccesos
		SELECT
			 @Perfil_Ident_INS					[Perfil_Ident]				
			,[EmpleadoId]				
			,[Nivel]					
			,1									Active
			,@UserEmployeeId					CreatedBy				
			,@FechaActual						CreatedDate				
			,NULL								DeactivatedDate			
			,NULL								DeactivatedBy			
			,@UserEmployeeId					LastModifiedBy			
			,@FechaActual						LastModifiedDate			
			,HOST_NAME()						[LastModifiedFromPCName]	
		FROM [app620].[CatPerfilEmpleadosAccesos]
		WHERE Perfil_Ident = @Perfil_Ident

		--SELECT *
		--FROM [app620].[CatPerfilEmpleadosAccesos]
		--WHERE Perfil_Ident = @Perfil_Ident_INS

		END
	ELSE
		SET @Estatus = -1
END
