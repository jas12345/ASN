USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[TraCommentSi]    Script Date: 23/08/2019 04:36:19 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[TraCommentSi]
@UserCCMSID int, --El usuario que hace el movimiento
@FolioId int, -- El Id del Folio
@EID int, --EL employeeId al que le esta haciendo el movimiento
@ConceptoId int, -- EL conceptoId del registro
@Comentario nvarchar(MAX)
AS
BEGIN
	if EXISTS(SELECT 1 FROM [app620].[CatEmpleadosSolicitudes] WHERE FolioSolicitud = @FolioId AND Empleado_Ident = @EID AND ConceptoId = @ConceptoId)
	BEGIN
		INSERT INTO [app620].[TraComment] (
			[FolioId]
			,[EmployeeId]
			,[ConceptoId]
			,[Comment]
			,[Active]
			,[CreatedDate]
			,[CreatedBy]
			,[LastModifiedDate]
			,[LastModifiedBy]
			,[DeactivatedBy]
			,[DeactivationDate]
			,[LastModifiedFromPCName])
		VALUES (
			@FolioId
			,@EID
			,@ConceptoId
			,@Comentario
			,1
			,GETDATE()
			,@UserCCMSID
			,GETDATE()
			,@UserCCMSID
			,NULL
			,NULL
			,HOST_NAME())
	END
END
