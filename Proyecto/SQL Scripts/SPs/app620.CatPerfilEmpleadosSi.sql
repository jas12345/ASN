USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosSi]    Script Date: 03/05/2019 12:55:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatPerfilEmpleadosSi]
	 @NombrePerfilEmpleados VARCHAR(50)
	,@Country_Ident INT
	,@City_Ident INT
	,@Company_Ident INT
	,@Location_Ident INT
	,@Client_Ident INT
	,@Program_Ident INT
	,@Contract_Type_Ident INT
	,@ConceptoId INT
	,@TipoAccesoId INT

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

	IF NOT EXISTS	
			(
				SELECT 1 
				FROM [app620].[CatPerfilEmpleados] 
				WHERE [NombrePerfilEmpleados] = @NombrePerfilEmpleados
			)

		BEGIN
			INSERT INTO [app620].[CatPerfilEmpleados]
			   (
					[NombrePerfilEmpleados]
				   ,[Country_Ident]
				   ,[City_Ident]
				   ,[Company_Ident]
				   ,[Location_Ident]
				   ,[Client_Ident]
				   ,[Program_Ident]
				   ,[Contract_Type_Ident]
				   ,ConceptoId 
				   ,TipoAccesoId 

				   ,[CreatedBy]
				   ,[LastModifiedBy]
			   )
		 VALUES
				(
					 @NombrePerfilEmpleados
					,@Country_Ident
					,@City_Ident
					,@Company_Ident
					,@Location_Ident
					,@Client_Ident
					,@Program_Ident
					,@Contract_Type_Ident
					,@ConceptoId
					,@TipoAccesoId

					,@UserEmployeeId 
					,@UserEmployeeId 
				)
		END
	ELSE
		SET @Estatus = -1

END
