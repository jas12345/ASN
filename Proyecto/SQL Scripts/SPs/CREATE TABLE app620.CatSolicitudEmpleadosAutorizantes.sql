USE [ASN]
GO

/****** Object:  Table [app620].[CatSolicitudEmpleadosAutorizantes]    Script Date: 01/05/2019 12:57:41 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[CatSolicitudEmpleadosAutorizantes](
	[FolioSolicitud] [int] NOT NULL,
	[Empleado_Ident] [int] NOT NULL,
	[Autorizador_Ident] [int] NOT NULL,
	[Consecutivo] [int] NOT NULL,
	[Obligatorio] [bit] NOT NULL,
	[Autorizado] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DeactivatedBy] [int] NULL,
	[DeactivatedDate] [datetime] NULL,
	[LastModifiedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[LastModifiedFromPCName] [varchar](64) NOT NULL,
 CONSTRAINT [PK__CatSolicitudEmpleadosAutorizantes] PRIMARY KEY CLUSTERED 
(
	[FolioSolicitud] ASC,
	[Empleado_Ident] ASC,
	[Autorizador_Ident] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosAutorizantes] ADD  CONSTRAINT [DF_CatSolicitudEmpleadosAutorizantes_Active]  DEFAULT ((1)) FOR [Active]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosAutorizantes] ADD  CONSTRAINT [DF_CatSolicitudEmpleadosAutorizantes_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosAutorizantes] ADD  CONSTRAINT [DF_CatSolicitudEmpleadosAutorizantes_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosAutorizantes] ADD  CONSTRAINT [DF_CatSolicitudEmpleadosAutorizantes_LastModifiedBy]  DEFAULT ((0)) FOR [LastModifiedBy]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosAutorizantes] ADD  CONSTRAINT [DF_CatSolicitudEmpleadosAutorizantes_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosAutorizantes] ADD  CONSTRAINT [DF_CatSolicitudEmpleadosAutorizantes_LastModifiedFromPCName]  DEFAULT (host_name()) FOR [LastModifiedFromPCName]
GO






