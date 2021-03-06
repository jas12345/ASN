USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosAccesosSi]    Script Date: 04/06/2019 06:41:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatPerfilEmpleadosAccesosSi]
	 @EmpleadoId	INT
	,@Perfil_Ident	INT
	,@Nivel			INT = NULL

	,@UserEmployeeId	INT
	,@Active			BIT
	,@Estatus			INT = 0 OUTPUT
AS
BEGIN
		
	DECLARE @FechaActual DATETIME
	DECLARE @UPDATE INT

	-- Se inicializa @Estatus a cero si el valor de entrada es NULL
	SET @Estatus = ISNULL(@Estatus, 0)

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
	- 0 = Proceso sin error
	- -1 = Ya existe un registro de Acceso para ese empleado
	*/
	
	SELECT @UPDATE = 1 
	FROM CatPerfilEmpleadosAccesos
	WHERE Perfil_Ident = @Perfil_Ident
	AND @EmpleadoId = @EmpleadoId

	SET @FechaActual = GETDATE();

	IF ISNULL(@UPDATE, 0) = 1

		BEGIN
			-- Se actualizan registros a estatus Activo cuando ya aparece en la BD
			UPDATE [app620].[CatPerfilEmpleadosAccesos]
			SET 
				Nivel						= @Nivel,
				LastModifiedBy				= @UserEmployeeId,
				LastModifiedDate			= @FechaActual,

				DeactivatedBy				= NULL,
				DeactivatedDate				= NULL,
				LastModifiedFromPCName		= HOST_NAME(),
				[Active]					= 1
			WHERE
				Perfil_Ident				= @Perfil_Ident
			--AND
			--	Active						= 1
			AND
				EmpleadoId					= @EmpleadoId
		END
	ELSE
		BEGIN
	-- Se insertan las claves que no existen en la tabla CatPerfilEmpleadosAccesos
			INSERT INTO [app620].[CatPerfilEmpleadosAccesos]
				(
					Perfil_Ident,
					EmpleadoId,
					Nivel,

					[CreatedBy],
					[CreatedDate],
					[LastModifiedBy]
				)
			SELECT
				@EmpleadoId,
				@Perfil_Ident,
				@Nivel,

				@UserEmployeeId, 
				@FechaActual,
				@UserEmployeeId 
		END


END
