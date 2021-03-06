/****** Object:  Trigger [app620].[CatSolicitudEmpleadosAutorizantesT]    Script Date: 02/09/2019 07:50:37 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Javier Raygoza	
-- Create date: 2019-08-28
-- Description:	Graba una copia de cada registro de esta tabla
-- =============================================
CREATE TRIGGER [app620].[CatSolicitudEmpleadosAutorizantesT]
   ON  [app620].[CatSolicitudEmpleadosAutorizantes]
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	--UPDATE
	IF EXISTS(SELECT * from inserted) AND EXISTS (SELECT * from deleted)
	BEGIN
		INSERT INTO app620.CatSolicitudEmpleadosAutorizantesLog
		(
			[FolioSolicitud], 
			[Empleado_Ident], 
			[ConceptoId], 
			[NivelAutorizacion], 
			[Autorizador_Ident], 
			[Obligatorio], 
			[MontoAutorizacionAutomatica], 
			[Pendiente], 
			[Autorizado], 
			[Rechazado], 
			[Cancelado], 
			[MotivoRechazo], 
			[Active], 
			[CreatedBy], 
			[CreatedDate], 
			[DeactivatedBy], 
			[DeactivatedDate], 
			[LastModifiedBy], 
			[LastModifiedDate], 
			[LastModifiedFromPCName], 
			[Operation]
		)
		SELECT
			[FolioSolicitud], 
			[Empleado_Ident], 
			[ConceptoId], 
			[NivelAutorizacion], 
			[Autorizador_Ident], 
			[Obligatorio], 
			[MontoAutorizacionAutomatica], 
			[Pendiente], 
			[Autorizado], 
			[Rechazado], 
			[Cancelado], 
			[MotivoRechazo], 
			[Active], 
			[CreatedBy], 
			[CreatedDate], 
			[DeactivatedBy], 
			[DeactivatedDate], 
			[LastModifiedBy], 
			[LastModifiedDate], 
			[LastModifiedFromPCName], 
			'UPD'
		FROM
			inserted i
	END
    
	--INSERT
	If exists (Select * from inserted) and not exists(Select * from deleted)
	begin
		INSERT INTO app620.CatSolicitudEmpleadosAutorizantesLog
		(
			[FolioSolicitud], 
			[Empleado_Ident], 
			[ConceptoId], 
			[NivelAutorizacion], 
			[Autorizador_Ident], 
			[Obligatorio], 
			[MontoAutorizacionAutomatica], 
			[Pendiente], 
			[Autorizado], 
			[Rechazado], 
			[Cancelado], 
			[MotivoRechazo], 
			[Active], 
			[CreatedBy], 
			[CreatedDate], 
			[DeactivatedBy], 
			[DeactivatedDate], 
			[LastModifiedBy], 
			[LastModifiedDate], 
			[LastModifiedFromPCName], 
			[Operation]
		)
		SELECT
			[FolioSolicitud], 
			[Empleado_Ident], 
			[ConceptoId], 
			[NivelAutorizacion], 
			[Autorizador_Ident], 
			[Obligatorio], 
			[MontoAutorizacionAutomatica], 
			[Pendiente], 
			[Autorizado], 
			[Rechazado], 
			[Cancelado], 
			[MotivoRechazo], 
			[Active], 
			[CreatedBy], 
			[CreatedDate], 
			[DeactivatedBy], 
			[DeactivatedDate], 
			[LastModifiedBy], 
			[LastModifiedDate], 
			[LastModifiedFromPCName], 
			'INS'
		FROM
			inserted i
	end


END
