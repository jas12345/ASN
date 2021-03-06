USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudEmpleadosAutorizantesSI]    Script Date: 01/10/2019 04:30:23 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatSolicitudEmpleadosAutorizantesSI]
@FolioSolicitud INT = 0
,@Empleado_Ident INT = 0
,@Autorizador_Ident INT = 0
,@NivelAutorizacion INT =0
,@Obligatorio BIT
,@MontoAutorizacionAutomatica DECIMAL(18,2)
,@Accion INT = 0
,@TTAutorizador_Ident BIT
,@TTNivelAutorizacion BIT
,@TTMontoAutorizacionAutomatica BIT
,@Active BIT
,@UserEmployeeId INT
,@Estatus INT = 0 OUTPUT
AS
BEGIN

IF EXISTS(SELECT 1 FROM app620.CatSolicitudEmpleadosAutorizantes WHERE FolioSolicitud = @FolioSolicitud AND Empleado_Ident =@Empleado_Ident AND Autorizador_Ident =@Autorizador_Ident)
SET @Estatus =-1

IF(@Estatus =0)
BEGIN
INSERT INTO app620.CatSolicitudEmpleadosAutorizantes
(
	FolioSolicitud
    ,Empleado_Ident
    ,Autorizador_Ident
    ,NivelAutorizacion
    ,Obligatorio
    ,MontoAutorizacionAutomatica
    ,Autorizado
    ,Rechazado
    ,Cancelado
    ,Active
    ,CreatedBy
    ,CreatedDate
)VALUES
(
	@FolioSolicitud
    ,@Empleado_Ident
    ,@Autorizador_Ident
    ,@NivelAutorizacion
    ,@Obligatorio--Obligatorio
    ,@MontoAutorizacionAutomatica
    ,(CASE WHEN @Accion =2 THEN 1 ELSE 0 END)--Autorizado
    ,(CASE WHEN @Accion =3 THEN 1 ELSE 0 END)--Rechazado
    ,(CASE WHEN @Accion =4 THEN 1 ELSE 0 END)--Cancelado
    ,1
	,@UserEmployeeId
	,GETDATE()
)
END
ELSE IF @TTAutorizador_Ident =1 OR @TTNivelAutorizacion = 1 OR @TTMontoAutorizacionAutomatica =1
BEGIN
	IF @TTAutorizador_Ident = 1
	BEGIN

		DECLARE @TempEmpleadosSolicitud TABLE (Id INT IDENTITY(1, 1),idEmpleado INT)
		DECLARE @indiceBase int=1,@TotalRegistros int=0;
		SELECT @TotalRegistros=COUNT(*) FROM [app620].[CatEmpleadosSolicitudes] WHERE FolioSolicitud = @FolioSolicitud AND Active=1

		INSERT INTO @TempEmpleadosSolicitud (idEmpleado)
		SELECT Empleado_Ident FROM [app620].[CatEmpleadosSolicitudes] WHERE FolioSolicitud = @FolioSolicitud AND Active=1

		WHILE @indiceBase <= @TotalRegistros
			BEGIN

				DECLARE @CatEmpleado_Id INT = 0
				SELECT @CatEmpleado_Id= idEmpleado  FROM @TempEmpleadosSolicitud WHERE Id=@indiceBase

				IF NOT EXISTS(SELECT 1 FROM [app620].CatSolicitudEmpleadosAutorizantes WHERE FolioSolicitud = @FolioSolicitud AND Empleado_Ident = @CatEmpleado_Id)
				BEGIN
					INSERT INTO app620.CatSolicitudEmpleadosAutorizantes
						(
							FolioSolicitud
							,Empleado_Ident
							,Autorizador_Ident
							,NivelAutorizacion
							,Obligatorio
							,MontoAutorizacionAutomatica
							,Autorizado
							,Rechazado
							,Cancelado
							,Active
							,CreatedBy
							,CreatedDate
						)VALUES
						(
							@FolioSolicitud
							,@CatEmpleado_Id
							,@Autorizador_Ident
							,@NivelAutorizacion
							,@Obligatorio--Obligatorio
							,@MontoAutorizacionAutomatica
							,(CASE WHEN @Accion =2 THEN 1 ELSE 0 END)--Autorizado
							,(CASE WHEN @Accion =3 THEN 1 ELSE 0 END)--Rechazado
							,(CASE WHEN @Accion =4 THEN 1 ELSE 0 END)--Cancelado
							,1
							,@UserEmployeeId
							,GETDATE()
						)
				END
				ELSE
				BEGIN
					UPDATE app620.CatSolicitudEmpleadosAutorizantes 
					SET
					 Autorizador_Ident	= @Autorizador_Ident
					,LastModifiedBy		= @UserEmployeeId
					,LastModifiedDate	= GETDATE()
					WHERE
						FolioSolicitud = @FolioSolicitud AND Active = 1
				END

				SET @indiceBase= @indiceBase+1
			END

	END

	IF @TTNivelAutorizacion = 1
	BEGIN
		UPDATE app620.CatSolicitudEmpleadosAutorizantes
		SET
			NivelAutorizacion	= @NivelAutorizacion
			,LastModifiedBy		= @UserEmployeeId
			,LastModifiedDate	= GETDATE()
		WHERE
			FolioSolicitud = @FolioSolicitud AND Active = 1
	END

	IF @TTMontoAutorizacionAutomatica =1
	BEGIN
		UPDATE app620.CatSolicitudEmpleadosAutorizantes
		SET
			MontoAutorizacionAutomatica	= @MontoAutorizacionAutomatica
			,LastModifiedBy		= @UserEmployeeId
			,LastModifiedDate	= GETDATE()
		WHERE
			FolioSolicitud = @FolioSolicitud AND Active = 1
	END

END
ELSE
BEGIN
	UPDATE app620.CatSolicitudEmpleadosAutorizantes 
	SET
     Autorizador_Ident	= @Autorizador_Ident
    ,NivelAutorizacion	= @NivelAutorizacion
    ,Obligatorio		= @Obligatorio--Obligatorio
    ,MontoAutorizacionAutomatica = @MontoAutorizacionAutomatica
    ,Autorizado			= (CASE WHEN @Accion =2 THEN 1 ELSE 0 END)--Autorizado
    ,Rechazado			= (CASE WHEN @Accion =3 THEN 1 ELSE 0 END)--Rechazado
    ,Cancelado			= (CASE WHEN @Accion =4 THEN 1 ELSE 0 END)--Cancelado
    ,Active				= @Active
	,LastModifiedBy		= @UserEmployeeId
	,LastModifiedDate	= GETDATE()
	WHERE
		FolioSolicitud = @FolioSolicitud AND Empleado_Ident=@Empleado_Ident
END
END
