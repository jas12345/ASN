USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatConsecutivoPeriodosSu]    Script Date: 15/03/2019 06:23:38 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[CatConsecutivoPeriodosSu]
	 @AnioId				INT
	,@MesId					INT
	,@ConsecutivoId			VARCHAR(5)
	,@PeriodicidadNominaId	VARCHAR(5)
	,@FechaInicio			VARCHAR(15)
	,@FechaCierre			VARCHAR(15)

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

	SET @FechaActual = GETDATE();

	-- Se inicializa @Estatus a cero si el valor de entrada es NULL
	SET @Estatus = ISNULL(@Estatus, 0)

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
		 0 = Proceso sin error
		-1 = Ya existe un registro con la misma descripción
	*/
	
		UPDATE [app620].[CatConsecutivoPeriodos]
		SET 
			 FechaInicio			= @FechaInicio
			,FechaCierre			= @FechaCierre

			,[Active]				= @Active
			,LastModifiedBy			= @UserEmployeeId
			,LastModifiedDate		= @FechaActual

			,DeactivatedBy			= IIF(@Active=1,NULL,@UserEmployeeId)
			,DeactivatedDate		= IIF(@Active=1,NULL,@FechaActual)
			,LastModifiedFromPCName	= HOST_NAME()
		WHERE
			AnioId					= @AnioId				
		AND MesId					= @MesId
		AND ConsecutivoId			= @ConsecutivoId
		AND PeriodicidadNominaId	= @PeriodicidadNominaId

END
