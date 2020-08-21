USE [ASN]
GO

/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosSu]    Script Date: 21/08/2020 8:55:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [app620].[CatPerfilEmpleadosSu]
	 @Perfil_Ident INT
	,@NombrePerfilEmpleados VARCHAR (50)

	,@Country_Ident INT = -1
	,@City_Ident INT = -1
	,@Location_Ident INT = -1
	,@Client_Ident VARCHAR(1500)		--INT = -1
	,@Program_Ident INT = -1
	,@Contract_Type_Ident INT = -1
	,@ConceptoId VARCHAR(1500)		--INT = -1
	,@TipoAccesoId INT = 1

	,@UserEmployeeId INT
	,@Active BIT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	DECLARE
		 @FechaActual DATETIME
		,@DeactivatedBy INT
		,@DeactivatedDate DATETIME
		,@LastModifiedBy INT
		,@LastModifiedDate DATETIME

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
	- 0 = Proceso sin error
	- -1 = Ya existe un registro con la misma descripción
	*/
	
	SET @FechaActual = GETDATE();

	IF EXISTS		(
						SELECT 1 
						FROM [app620].[CatPerfilEmpleados] 
						WHERE [Perfil_Ident] = @Perfil_Ident
					)
	AND NOT EXISTS	(
						SELECT 1 
						FROM [app620].[CatPerfilEmpleados] 
						WHERE	Perfil_Ident			<> @Perfil_Ident 
						AND		NombrePerfilEmpleados	= @NombrePerfilEmpleados
					)
		BEGIN
			UPDATE [app620].[CatPerfilEmpleados]
			SET 
				 [NombrePerfilEmpleados]	= @NombrePerfilEmpleados

				,[Country_Ident]			= @Country_Ident
				,[City_Ident]				= @City_Ident
				,[Location_Ident]			= @Location_Ident
				--,[Client_Ident]				= @Client_Ident
				,[Program_Ident]			= @Program_Ident
				,[Contract_Type_Ident]		= @Contract_Type_Ident
				--,[ConceptoId]				= @ConceptoId
				,[TipoAccesoId]				= @TipoAccesoId

				,[Active]					= @Active
				,LastModifiedBy				= @UserEmployeeId
				,LastModifiedDate			= @FechaActual

				,DeactivatedBy				= IIF(@Active=1,NULL,@UserEmployeeId)
				,DeactivatedDate			= IIF(@Active=1,NULL,@FechaActual)
				,LastModifiedFromPCName		= HOST_NAME()
			WHERE
				Perfil_Ident				= @Perfil_Ident


		--Se insertan todos los registros de relación en RelPerfilEmpleadosClientes
		if exists(select * from fnSplit(@Client_Ident,',') Cli where Cli.item = '-1')
		begin 
				DELETE app620.RelPerfilEmpleadosClientes
				where Perfil_ident = @Perfil_ident 	
							
				INSERT INTO app620.RelPerfilEmpleadosClientes 
				select	@Perfil_Ident Perfil_Ident, Client_ident		
				from	[app620].[CatClientVw]						as vw WITH (NOLOCK)
		end
		else
			begin
				INSERT INTO app620.RelPerfilEmpleadosClientes 
				SELECT @Perfil_Ident Perfil_Ident, Cli.item Client_Ident
				FROM fnSplit(@Client_Ident,',') Cli
				WHERE Cli.item NOT IN (
					SELECT Cli.item 
					FROM
						 RelPerfilEmpleadosClientes RPEC
						,fnSplit(@Client_Ident,',') Cli
					WHERE RPEC.Perfil_Ident = @Perfil_Ident
					AND RPEC.Client_Ident = Cli.item
				)

				--Se desactivan todos los registros de relación en CatPerfilesClientes
				DELETE app620.RelPerfilEmpleadosClientes
				WHERE Client_Ident NOT IN (SELECT Cli.item Client_Ident FROM fnSplit(@Client_Ident,',') Cli)
				AND Perfil_Ident = @Perfil_Ident
			end
		--Se insertan todos los registros de relación en RelPerfilEmpleadosConceptos
		INSERT INTO app620.RelPerfilEmpleadosConceptos 
		SELECT @Perfil_Ident Perfil_Ident, Con.item ConceptoId
		FROM fnSplit(@ConceptoId,',') Con
		WHERE Con.item NOT IN (
			SELECT Con.item 
			FROM
				 RelPerfilEmpleadosConceptos RPEC
				,fnSplit(@ConceptoId,',') Con
			WHERE RPEC.Perfil_Ident = @Perfil_Ident
			AND RPEC.ConceptoId = Con.item
		)

		--Se desactivan todos los registros de relación en CatPerfilesConceptos
		DELETE app620.RelPerfilEmpleadosConceptos
		WHERE ConceptoId NOT IN (SELECT Con.item ConceptoId FROM fnSplit(@ConceptoId,',') Con)
		AND Perfil_Ident = @Perfil_Ident

		END
	ELSE
		SET @Estatus = -1
END
GO

