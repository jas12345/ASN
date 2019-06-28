USE [ASN]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] DROP CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_LastModifiedFromPCName]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] DROP CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_LastModifiedDate]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] DROP CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_LastModifiedBy]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] DROP CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_CreatedDate]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] DROP CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_CreatedBy]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] DROP CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_Active]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] DROP CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_AutorizacionAutomatica]
GO

/****** Object:  Table [app620].[CatConceptosNivelMontoAutorizacion]    Script Date: 26/06/2019 05:47:17 p. m. ******/
DROP TABLE [app620].[CatConceptosNivelMontoAutorizacion]
GO

/****** Object:  Table [app620].[CatConceptosNivelMontoAutorizacion]    Script Date: 26/06/2019 05:47:17 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[CatConceptosNivelMontoAutorizacion](
	[ConceptoId] [int] NOT NULL,
	[NivelId] [int] NOT NULL,
	[MontoAutorizacion] [decimal](18, 2) NULL,
	[AutorizacionAutomatica] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DeactivatedDate] [datetime] NULL,
	[DeactivatedBy] [int] NULL,
	[LastModifiedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[LastModifiedFromPCName] [varchar](64) NOT NULL,
 CONSTRAINT [PK_ConceptosNivelMontoAutorizacion] PRIMARY KEY CLUSTERED 
(
	[ConceptoId] ASC,
	[NivelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] ADD  CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_AutorizacionAutomatica]  DEFAULT ((0)) FOR [AutorizacionAutomatica]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] ADD  CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_Active]  DEFAULT ((1)) FOR [Active]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] ADD  CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] ADD  CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] ADD  CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_LastModifiedBy]  DEFAULT ((0)) FOR [LastModifiedBy]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] ADD  CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO

ALTER TABLE [app620].[CatConceptosNivelMontoAutorizacion] ADD  CONSTRAINT [DF_CatConceptosNivelMontoAutorizacion_LastModifiedFromPCName]  DEFAULT (host_name()) FOR [LastModifiedFromPCName]
GO


