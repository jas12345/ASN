USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatConsecutivoPeriodosSi]    Script Date: 15/03/2019 06:24:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [app620].[CatConsecutivoPeriodosSi]

	 @AnioId				INT
	,@MesId					INT
	,@ConsecutivoId			VARCHAR(5)
	,@PeriodicidadNominaId	VARCHAR(5)
	,@FechaInicio			VARCHAR(15)
	,@FechaCierre			VARCHAR(15)

	,@UserEmployeeId		INT
	,@Estatus				INT = 0 OUTPUT
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
		-1 = Ya existe un registro con la misma clave de Año, Mes, Periodicidad y Consecutivo
	*/
	
	IF EXISTS	(
					SELECT 1 
					FROM [app620].[CatConsecutivoPeriodos] 
					WHERE AnioId				= 	 @AnioId				
					AND MesId					= 	 @MesId					
					AND ConsecutivoId			= 	 @ConsecutivoId			
					AND PeriodicidadNominaId	= 	 @PeriodicidadNominaId	
 
				)
		SET @Estatus = @Estatus -1

	IF @Estatus = 0
		BEGIN
			INSERT INTO [app620].[CatConsecutivoPeriodos]
			   (
					 AnioId						
					,MesId							
					,ConsecutivoId			
					,PeriodicidadNominaId
					,FechaInicio			
					,FechaCierre			

				   ,[CreatedBy]
				   ,[LastModifiedBy]
			   )
		 VALUES
			   (
					 @AnioId						
					,@MesId							
					,@ConsecutivoId			
					,@PeriodicidadNominaId
					,@FechaInicio			
					,@FechaCierre			

					,@UserEmployeeId 
					,@UserEmployeeId 
				)
		END

END
