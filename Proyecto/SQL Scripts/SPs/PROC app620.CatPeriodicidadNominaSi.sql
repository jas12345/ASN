USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatPeriodicidadNominaSi]    Script Date: 06/04/2019 11:30:52 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [app620].[CatPeriodicidadNominaSi]
	 @PeriodicidadNominaId VARCHAR(5)
	,@Descripcion VARCHAR(50)
	,@Consecutivos INT
	,@UserEmployeeId INT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	DECLARE
		 @FechaActual DATETIME

	SET @FechaActual = GETDATE();
	
	-- Se inicializa @Estatus a cero si el valor de entrada es NULL
	SET @Estatus = ISNULL(@Estatus, 0)

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
		 0 = Proceso sin error
		-1 = Ya existe un registro con la misma descripción
		-2 = Ya existe un registro con la misma clave
		-3 = Ya existe un registro con la misma clave y/o descripción
	*/
	
	IF EXISTS	(
					SELECT 1 
					FROM [app620].[CatPeriodicidadNomina] 
					WHERE Descripcion = @Descripcion 
				)
		SET @Estatus = @Estatus -1

	IF EXISTS	(
					SELECT 1 
					FROM [app620].[CatPeriodicidadNomina] 
					WHERE [PeriodicidadNominaId] = @PeriodicidadNominaId 
				)
		SET @Estatus = @Estatus -2

	IF @Estatus = 0
		BEGIN
			INSERT INTO [app620].[CatPeriodicidadNomina]
			   (
					[PeriodicidadNominaId]
				   ,[Descripcion]
				   ,[Consecutivos]
				   ,[CreatedBy]
				   ,[LastModifiedBy]
			   )
		 VALUES
				(
					 @PeriodicidadNominaId 
					,@Descripcion
					,@Consecutivos
					,@UserEmployeeId 
					,@UserEmployeeId 
				)

			EXEC [app620].CargaPivote @Consecutivos

			INSERT INTO CatConsecutivoPeriodicidad
			(
				 [ConsecutivoId]
				,[PeriodicidadNominaId]
				,[CreatedBy]
				,[LastModifiedBy]
			)
			SELECT iVarChar, @PeriodicidadNominaId, @UserEmployeeId, @UserEmployeeId
			FROM Pivote
			WHERE i BETWEEN 1 AND @Consecutivos
		END

END
