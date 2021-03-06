USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosAccesosSi]    Script Date: 23/04/2019 05:23:36 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatPerfilEmpleadosAccesosSi]
	 @Perfil_Ident INT
	,@SelectedKeyNames VARCHAR(500)
	--,@EmpleadoId INT

	,@UserEmployeeId INT
	,@Active BIT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	
	Create table	#tempSelectedKeys (EmpleadoId INT)
	Insert into		#tempSelectedKeys (EmpleadoId)
		(
			SELECT	item 
			FROM	dbo.fnSplit(@SelectedKeyNames,',')
		)
	
	DECLARE @FechaActual DATETIME

	-- Se inicializa @Estatus a cero si el valor de entrada es NULL
	SET @Estatus = ISNULL(@Estatus, 0)

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
	- 0 = Proceso sin error
	- -1 = Ya existe un registro de Acceso para ese empleado
	*/
	
	SET @FechaActual = GETDATE();

	-- Se actualizan registros a estatus Activo cuando no aparece en la lista
	UPDATE [app620].[CatPerfilEmpleadosAccesos]
	SET 
		[Active]					= 0,
		LastModifiedBy				= @UserEmployeeId,
		LastModifiedDate			= @FechaActual,

		DeactivatedBy				= @UserEmployeeId,
		DeactivatedDate				= @FechaActual,
		LastModifiedFromPCName		= HOST_NAME()
	WHERE
		Perfil_Ident				= @Perfil_Ident
	AND
		Active						= 1
	AND
		EmpleadoId IN				(SELECT EmpleadoId FROM #tempSelectedKeys)

	-- Se actualizan registros a estatus Inactivo cuando no aparece en la lista
	UPDATE [app620].[CatPerfilEmpleadosAccesos]
	SET 
		[Active]					= 1,
		LastModifiedBy				= @UserEmployeeId,
		LastModifiedDate			= @FechaActual,

		DeactivatedBy				= NULL,
		DeactivatedDate				= NULL,
		LastModifiedFromPCName		= HOST_NAME()
	WHERE
		Perfil_Ident				= @Perfil_Ident
	AND
		Active						= 0
	AND
		EmpleadoId NOT IN			(SELECT EmpleadoId FROM #tempSelectedKeys)

	-- Se insertan las claves que no existen en la tabla CatPerfilEmpleadosAccesos
	INSERT INTO [app620].[CatPerfilEmpleadosAccesos]
		(
			Perfil_Ident,
			EmpleadoId,

			[CreatedBy],
			[LastModifiedBy]
		)
	SELECT
		@Perfil_Ident,
		SK.EmpleadoId,
		--@EmpleadoId,

		@UserEmployeeId, 
		@UserEmployeeId 
	FROM #tempSelectedKeys SK	
	WHERE SK.EmpleadoId NOT IN	(
									SELECT EmpleadoId 
									FROM app620.CatPerfilEmpleadosAccesos
									WHERE Perfil_Ident = @Perfil_Ident
								)
	--AND	

	--IF NOT EXISTS	
	--		(
	--			SELECT 1 
	--			FROM [app620].[CatPerfilEmpleadosAccesos]
	--			WHERE	Perfil_Ident	= @Perfil_Ident
	--			AND		EmpleadoId		= @EmpleadoId
	--		)

	--	BEGIN
	--		INSERT INTO [app620].[CatPerfilEmpleadosAccesos]
	--		   (
	--				Perfil_Ident,
	--				EmpleadoId,

	--				[CreatedBy],
	--				[LastModifiedBy]
	--		   )
	--	 VALUES
	--			(
	--				@Perfil_Ident,
	--				@EmpleadoId,

	--				@UserEmployeeId, 
	--				@UserEmployeeId 
	--			)
	--	END
	--ELSE
	--	BEGIN
	--		UPDATE [app620].[CatPerfilEmpleadosAccesos]
	--		SET 
	--			[Active]					= @Active,
	--			LastModifiedBy				= @UserEmployeeId,
	--			LastModifiedDate			= @FechaActual,

	--			DeactivatedBy				= IIF(@Active=1,NULL,@UserEmployeeId),
	--			DeactivatedDate				= IIF(@Active=1,NULL,@FechaActual),
	--			LastModifiedFromPCName		= HOST_NAME()
	--		WHERE
	--			Perfil_Ident				= @Perfil_Ident
	--		AND
	--			EmpleadoId					= @EmpleadoId
	--	END

END
