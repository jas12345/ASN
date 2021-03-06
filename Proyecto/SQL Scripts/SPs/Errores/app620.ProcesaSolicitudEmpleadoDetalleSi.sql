USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[ProcesaSolicitudEmpleadoDetalleSi]    Script Date: 20/06/2019 12:06:55 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[ProcesaSolicitudEmpleadoDetalleSi]
@SolicitudId INT
,@ListaEmpleados VARCHAR(MAX)
,@ConceptoMotivoId INT
,@ListaConceptoMotivo VARCHAR(MAX)
,@AplicaAtodos BIT =0
,@UserEmployeeId INT
,@Estatus INT = 0 OUTPUT
AS
SET XACT_ABORT ON;
SET NOCOUNT ON;
BEGIN TRY
	BEGIN TRAN
	
	DECLARE @TempTableEmpleados TABLE (Id INT IDENTITY(1, 1),idEmp VARCHAR(100), estatus int default null)
	DECLARE @TempTableConceptos TABLE (Id INT IDENTITY(1, 1),idConceptoMotivo VARCHAR(100))

	INSERT INTO @TempTableEmpleados(idEmp)
	SELECT item FROM dbo.fnSplit(@ListaEmpleados,',')

	INSERT INTO @TempTableConceptos(idConceptoMotivo)
	SELECT item FROM dbo.fnSplit(@ListaConceptoMotivo,',')

	DECLARE @TotalRegistros Int = (Select count(*) from @TempTableEmpleados)	
	DECLARE @indiceBase int=1;

WHILE 	@indiceBase <= @TotalRegistros
BEGIN
	
	Declare @EmpleadoId Int= 0
	Declare @EstatusRegistro INT= NULL

	SELECT @EmpleadoId=idEmp, @EstatusRegistro=estatus FROM @TempTableEmpleados WHERE Id=@indiceBase
	
	IF @AplicaAtodos =0
		BEGIN
			DECLARE @Responsable INT=0
			SELECT @Responsable = Manager_Ident FROM [app620].[CatEmployeeCCMSVw] WHERE Ident = @EmpleadoId

			DECLARE @ExisteRegistro INT =0
			
			IF NOT EXISTS(SELECT 1 FROM [app620].CatSolicitudEmpleadosDetalle WHERE FolioSolicitud=@SolicitudId AND Empleado_Ident=@EmpleadoId AND CatConceptoMotivoId=@ConceptoMotivoId)
			SET @ExisteRegistro = 1

			IF @ExisteRegistro =0
				BEGIN
					EXEC [app620].[CatSolicitudEmpleadosDetalleSi]
									@SolicitudId = @SolicitudId,
									@CatEmpleadoId = @EmpleadoId,
									@CatConceptoMotivoId = @ConceptoMotivoId,
									@ResponsableId = @Responsable,
									@ParametroConceptoMonto = NULL,
									@Detalle = NULL,
									@PeriodoNomina = NULL,
									@UserEmployeeId = @UserEmployeeId
				END
			ELSE
				BEGIN
					UPDATE [app620].CatSolicitudEmpleadosDetalle SET Active=1 WHERE FolioSolicitud=@SolicitudId AND Empleado_Ident=@EmpleadoId AND CatConceptoMotivoId=@ConceptoMotivoId
				END
		END									
	--ELSE
	--BEGIN
	--	--Si aplica a todos se crean los registros y se le agrega el mismo ConceptoMotivo
	--	INSERT INTO [app620].CatSolicitudEmpleadosDetalle (CatSolicitudId, CatEmpleadoId, CatConceptoMotivoId, Active)
	--	--UPDATE [app620].CatSolicitudEmpleadosDetalle SET CatConceptoMotivoId=@ConceptoMotivoId, Active=1 WHERE CatSolicitudId=@SolicitudId
	--END

		SET @indiceBase= @indiceBase+1
END
	COMMIT TRAN;
END TRY
BEGIN CATCH  -- Modulo de manejo de errores
	
    DECLARE @Error_Number INT ,
        @Error_Severity INT ,
        @Error_State INT ,
        @Error_Procedure VARCHAR(1000) ,
        @Error_Line INT ,
        @Error_Message VARCHAR(8000);
    SELECT  @Error_Number = ERROR_NUMBER() ,
            @Error_Severity = ERROR_SEVERITY() ,
            @Error_State = ERROR_STATE() ,
            @Error_Procedure = ERROR_PROCEDURE() ,
            @Error_Line = ERROR_LINE() ,
            @Error_Message = ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
	
	RAISERROR(@Error_Message,@Error_Severity, @Error_State);	
END CATCH;