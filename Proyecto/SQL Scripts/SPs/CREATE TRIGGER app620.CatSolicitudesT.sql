/****** Object:  Trigger [app620].[CatSolicitudesT]    Script Date: 02/09/2019 07:48:17 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Javier Raygoza	
-- Create date: 2019-08-28
-- Description:	Graba una copia de cada registro de esta tabla
-- =============================================
CREATE TRIGGER [app620].[CatSolicitudesT]
   ON  [app620].[CatSolicitudes]
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	--UPDATE
	IF EXISTS(SELECT * from inserted) AND EXISTS (SELECT * from deleted)
	BEGIN
		INSERT INTO app620.CatSolicitudesLog
		(
			[FolioSolicitud], 
			[Fecha_Solicitud], 
			[Perfil_Ident], 
			[Solicitante_Ident], 
			[PeriodoNominaId], 
			[EstatusSolicitudId], 
			[Responsable_Ident], 
			[Active], 
			[CreatedBy], 
			[CreatedDate], 
			[DeactivatedDate], 
			[DeactivatedBy], 
			[LastModifiedBy], 
			[LastModifiedDate], 
			[LastModifiedFromPCName],
			[Operation]
		)
		SELECT
			[FolioSolicitud], 
			[Fecha_Solicitud], 
			[Perfil_Ident], 
			[Solicitante_Ident], 
			[PeriodoNominaId], 
			[EstatusSolicitudId], 
			[Responsable_Ident], 
			[Active], 
			[CreatedBy], 
			[CreatedDate], 
			[DeactivatedDate], 
			[DeactivatedBy], 
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
		INSERT INTO app620.CatSolicitudesLog
		(
			[FolioSolicitud], 
			[Fecha_Solicitud], 
			[Perfil_Ident], 
			[Solicitante_Ident], 
			[PeriodoNominaId], 
			[EstatusSolicitudId], 
			[Responsable_Ident], 
			[Active], 
			[CreatedBy], 
			[CreatedDate], 
			[DeactivatedDate], 
			[DeactivatedBy], 
			[LastModifiedBy], 
			[LastModifiedDate], 
			[LastModifiedFromPCName],
			[Operation]
		)
		SELECT
			[FolioSolicitud], 
			[Fecha_Solicitud], 
			[Perfil_Ident], 
			[Solicitante_Ident], 
			[PeriodoNominaId], 
			[EstatusSolicitudId], 
			[Responsable_Ident], 
			[Active], 
			[CreatedBy], 
			[CreatedDate], 
			[DeactivatedDate], 
			[DeactivatedBy], 
			[LastModifiedBy], 
			[LastModifiedDate], 
			[LastModifiedFromPCName],
			'INS'
		FROM
			inserted i
	end


END
