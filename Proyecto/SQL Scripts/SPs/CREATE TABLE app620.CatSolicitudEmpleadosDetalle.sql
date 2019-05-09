USE [ASN]
GO

/****** Object:  Table [app620].[CatSolicitudEmpleadosDetalle]    Script Date: 08/05/2019 10:51:33 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[CatSolicitudEmpleadosDetalle](
	[FolioSolicitud] [int] NOT NULL,
	[Empleado_Ident] [int] NOT NULL,
	[CatConceptoMotivoId] [int] NOT NULL,
	[ResponsableId] [int] NOT NULL,
	[PeriodoOriginalAnio_Id] [int] NULL,
	[PeriodoOriginalMes_Id] [int] NULL,
	[PeriodoOriginalConsecutivoid] [varchar](5) NULL,
	[PeriodoOriginalPeriodicidadNomina_Id] [varchar](5) NULL,
	[PeriodoOriginalTipoPeriodo_Id] [varchar](5) NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DeactivatedBy] [int] NULL,
	[DeactivatedDate] [datetime] NULL,
	[LastModifiedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[LastModifiedFromPCName] [varchar](64) NOT NULL,
 CONSTRAINT [PK__CatSolic__1326760DBC7939F9] PRIMARY KEY CLUSTERED 
(
	[FolioSolicitud] ASC,
	[Empleado_Ident] ASC,
	[CatConceptoMotivoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosDetalle] ADD  CONSTRAINT [DF_CatSolicitudEmpleadosDetalle_Active]  DEFAULT ((1)) FOR [Active]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosDetalle] ADD  CONSTRAINT [DF_CatSolicitudEmpleadosDetalle_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosDetalle] ADD  CONSTRAINT [DF_CatSolicitudEmpleadosDetalle_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosDetalle] ADD  CONSTRAINT [DF_CatSolicitudEmpleadosDetalle_LastModifiedBy]  DEFAULT ((0)) FOR [LastModifiedBy]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosDetalle] ADD  CONSTRAINT [DF_CatSolicitudEmpleadosDetalle_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosDetalle] ADD  CONSTRAINT [DF_CatSolicitudEmpleadosDetalle_LastModifiedFromPCName]  DEFAULT (host_name()) FOR [LastModifiedFromPCName]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_CatSolicitudEmpleadosDetalle_CatConceptosMotivos] FOREIGN KEY([CatConceptoMotivoId])
REFERENCES [app620].[CatConceptosMotivos] ([ConceptoMotivoId])
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosDetalle] CHECK CONSTRAINT [FK_CatSolicitudEmpleadosDetalle_CatConceptosMotivos]
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_CatSolicitudEmpleadosDetalle_CatEmpleadosSolicitudes] FOREIGN KEY([FolioSolicitud], [Empleado_Ident])
REFERENCES [app620].[CatEmpleadosSolicitudes] ([FolioSolicitud], [Empleado_Ident])
GO

ALTER TABLE [app620].[CatSolicitudEmpleadosDetalle] CHECK CONSTRAINT [FK_CatSolicitudEmpleadosDetalle_CatEmpleadosSolicitudes]
GO


