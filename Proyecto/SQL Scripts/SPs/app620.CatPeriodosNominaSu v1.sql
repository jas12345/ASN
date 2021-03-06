USE [ASN7]
GO
/****** Object:  StoredProcedure [app620].[CatPeriodosNominaSu]    Script Date: 31/03/2020 01:17:23 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatPeriodosNominaSu]
	 @AnioId INT = 0
	,@MesId INT = 0
	,@PeriodicidadNominaId VARCHAR(5) = NULL
	,@Consecutivo VARCHAR(5) = NULL
	,@TipoPeriodo VARCHAR(5) = NULL
	
	,@FechaInicio VARCHAR(20)
	,@FechaFin VARCHAR(20)
	,@FechaCaptura VARCHAR(20)
	,@FechaCierre VARCHAR(20)
	,@CountryIdents VARCHAR(50) NULL
	,@NombrePeriodo VARCHAR(50) NULL
	,@UserEmployeeId INT
	,@Active BIT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	DECLARE
		 @FechaActual DATETIME

	SET @FechaActual	= GETDATE();
	SET @Estatus		= ISNULL(@Estatus, 0)
	
	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
		 0 = Proceso sin error
		-1 = Ya existe un registro con el mismo nombre de periodo de nomina
	*/

	IF EXISTS (
		SELECT 1
		FROM [app620].[CatPeriodosNomina] 
		WHERE  NombrePeriodo = @NombrePeriodo
	)
	AND NOT EXISTS(
		SELECT 1
		FROM [app620].[CatPeriodosNomina] 
		WHERE
				AnioId					= @AnioId
			AND MesId					= @MesId
			AND	PeriodicidadNominaId	= @PeriodicidadNominaId
			AND ConsecutivoId			= @Consecutivo
			AND TipoPeriodo				= @TipoPeriodo
			AND NombrePeriodo			= @NombrePeriodo
	)
		BEGIN
			SET @Estatus = @Estatus -1
		END
	ELSE
		BEGIN
			UPDATE [app620].[CatPeriodosNomina]
			SET
				 FechaInicio			= @FechaInicio
				,FechaFin				= @FechaFin
				,FechaCaptura			= @FechaCaptura
				,FechaCierre			= @FechaCierre
				,CountryIdents			= @CountryIdents
				,NombrePeriodo			= @NombrePeriodo

				,Active					= @Active
				,LastModifiedBy			= @UserEmployeeId
				,LastModifiedDate		= @FechaActual

				,DeactivatedBy			= IIF(@Active=0,NULL,@UserEmployeeId)
				,DeactivatedDate		= IIF(@Active=0,NULL,@FechaActual)
				,LastModifiedFromPCName	= HOST_NAME()
			WHERE 
					PeriodicidadNominaId	= @PeriodicidadNominaId
				AND AnioId					= @AnioId
				AND MesId					= @MesId
				AND ConsecutivoId			= @Consecutivo
				AND TipoPeriodo				= @TipoPeriodo
		END
END