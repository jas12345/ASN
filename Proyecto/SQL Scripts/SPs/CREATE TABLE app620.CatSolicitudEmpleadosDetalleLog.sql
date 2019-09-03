/****** Object:  Table [app620].[CatSolicitudEmpleadosDetalleLog]    Script Date: 02/09/2019 07:46:24 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[CatSolicitudEmpleadosDetalleLog](
	[FolioSolicitud] [int] NULL,
	[Empleado_Ident] [int] NULL,
	[ConceptoId] [int] NULL,
	[ConceptoMotivoId] [int] NULL,
	[ResponsableId] [int] NULL,
	[PeriodoOriginalId] [int] NULL,
	[Active] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[DeactivatedBy] [int] NULL,
	[DeactivatedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedFromPCName] [varchar](64) NULL,
	[Operation] [nvarchar](10) NULL
) ON [PRIMARY]
GO


