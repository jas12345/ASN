USE [ASN_PE]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosCopy]    Script Date: 19/06/2020 08:54:17 a. m. ******/
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

	IF EXISTS		(
						SELECT 1 
						FROM [app620].[CatPerfilEmpleados] 
						WHERE	NombrePerfilEmpleados	= @NombrePerfilEmpleados
					)
	AND NOT EXISTS	(
						SELECT 1 
						FROM [app620].[CatPerfilEmpleados] 
						WHERE	NombrePerfilEmpleados	= @NombrePerfilEmpleados + '_Copia'
					)
		BEGIN
			DECLARE @inserted TABLE (
				[Perfil_Ident] [int]
			)

			INSERT INTO [app620].[CatPerfilEmpleados]
			OUTPUT Inserted.Perfil_Ident INTO @inserted
			SELECT TOP 1
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
				NombrePerfilEmpleados	= @NombrePerfilEmpleados				

			SELECT	TOP 1 @Perfil_Ident_INS = Perfil_Ident
			FROM @inserted;		

			--Se insertan todos los registros de relación en RelPerfilEmpleadosConceptos
			INSERT INTO app620.RelPerfilEmpleadosConceptos 
			SELECT
				 @Perfil_Ident_INS					[Perfil_Ident]
				,RPEC.[ConceptoId]
			FROM app620.RelPerfilEmpleadosConceptos RPEC
			JOIN app620.CatPerfilEmpleados			PE
			ON
				RPEC.Perfil_Ident					= PE.Perfil_Ident
			AND
				PE.NombrePerfilEmpleados			= @NombrePerfilEmpleados

			--Se insertan todos los registros de relación en RelPerfilEmpleadosClientes
			INSERT INTO app620.RelPerfilEmpleadosClientes 
			SELECT
				 @Perfil_Ident_INS					[Perfil_Ident]
				,RPECli.[Client_Ident]
			FROM app620.RelPerfilEmpleadosClientes	RPECli
			JOIN app620.CatPerfilEmpleados			PE
			ON
				RPECli.Perfil_Ident					= PE.Perfil_Ident
			AND
				PE.NombrePerfilEmpleados			= @NombrePerfilEmpleados

			--Se insertan todos los registros de app620.CatPerfilEmpleadosAccesos
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
				,HOST_NAME()						LastModifiedFromPCName	
			FROM app620.CatPerfilEmpleadosAccesos	PEA
			JOIN app620.CatPerfilEmpleados			PE
			ON
				PEA.Perfil_Ident					= PE.Perfil_Ident
			AND
				PE.NombrePerfilEmpleados			= @NombrePerfilEmpleados

		END
	ELSE
		SET @Estatus = -1
END
