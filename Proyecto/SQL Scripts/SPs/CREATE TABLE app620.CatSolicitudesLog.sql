/****** Object:  Table [app620].[CatSolicitudesLog]    Script Date: 02/09/2019 07:47:00 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[CatSolicitudesLog](
	[FolioSolicitud] [int] NOT NULL,
	[Fecha_Solicitud] [date] NULL,
	[Perfil_Ident] [int] NULL,
	[Solicitante_Ident] [int] NULL,
	[PeriodoNominaId] [int] NULL,
	[EstatusSolicitudId] [varchar](5) NULL,
	[Responsable_Ident] [int] NULL,
	[Active] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[DeactivatedDate] [datetime] NULL,
	[DeactivatedBy] [int] NULL,
	[LastModifiedBy] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedFromPCName] [varchar](64) NULL,
	[Operation] [nvarchar](10) NULL
) ON [PRIMARY]
GO


