/****** Object:  Table [app620].[CatSolicitudEmpleadosAutorizantesLog]    Script Date: 02/09/2019 07:45:39 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[CatSolicitudEmpleadosAutorizantesLog](
	[FolioSolicitud] [int] NULL,
	[Empleado_Ident] [int] NULL,
	[ConceptoId] [int] NULL,
	[NivelAutorizacion] [int] NULL,
	[Autorizador_Ident] [int] NULL,
	[Obligatorio] [bit] NULL,
	[MontoAutorizacionAutomatica] [decimal](18, 2) NULL,
	[Pendiente] [bit] NULL,
	[Autorizado] [bit] NULL,
	[Rechazado] [bit] NULL,
	[Cancelado] [bit] NULL,
	[MotivoRechazo] [varchar](2000) NULL,
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


