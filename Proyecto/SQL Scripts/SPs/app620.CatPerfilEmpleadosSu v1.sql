USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosSu]    Script Date: 04/11/2019 05:18:30 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[CatPerfilEmpleadosSu]
	 @Perfil_Ident INT
	,@NombrePerfilEmpleados VARCHAR (50)

	,@Country_Ident INT
	,@City_Ident INT
	,@Location_Ident INT
	,@Client_Ident INT
	,@Program_Ident INT
	,@Contract_Type_Ident INT
	,@ConceptoId INT
	,@TipoAccesoId INT

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
				,[Client_Ident]				= @Client_Ident
				,[Program_Ident]			= @Program_Ident
				,[Contract_Type_Ident]		= @Contract_Type_Ident
				,[ConceptoId]				= @ConceptoId
				,[TipoAccesoId]				= @TipoAccesoId

				,[Active]					= @Active
				,LastModifiedBy				= @UserEmployeeId
				,LastModifiedDate			= @FechaActual

				,DeactivatedBy				= IIF(@Active=1,NULL,@UserEmployeeId)
				,DeactivatedDate			= IIF(@Active=1,NULL,@FechaActual)
				,LastModifiedFromPCName		= HOST_NAME()
			WHERE
				Perfil_Ident				= @Perfil_Ident

		END
	ELSE
		SET @Estatus = -1
END
