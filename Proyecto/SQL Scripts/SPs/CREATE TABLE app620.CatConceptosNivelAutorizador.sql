USE [ASN]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] DROP CONSTRAINT [DF_CatConceptosNivelAutorizador_LastModifiedFromPCName]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] DROP CONSTRAINT [DF_CatConceptosNivelAutorizador_LastModifiedDate]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] DROP CONSTRAINT [DF_CatConceptosNivelAutorizador_LastModifiedBy]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] DROP CONSTRAINT [DF_CatConceptosNivelAutorizador_CreatedDate]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] DROP CONSTRAINT [DF_CatConceptosNivelAutorizador_CreatedBy]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] DROP CONSTRAINT [DF_CatConceptosNivelAutorizador_Active]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] DROP CONSTRAINT [DF_CatConceptosNivelAutorizador_AutorizacionObligatoria]
GO

/****** Object:  Table [app620].[CatConceptosNivelAutorizador]    Script Date: 26/06/2019 05:49:46 p. m. ******/
DROP TABLE [app620].[CatConceptosNivelAutorizador]
GO

/****** Object:  Table [app620].[CatConceptosNivelAutorizador]    Script Date: 26/06/2019 05:49:46 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[CatConceptosNivelAutorizador](
	[ConceptoId] [int] NOT NULL,
	[NivelId] [int] NOT NULL,
	[AutorizadorIdent] [int] NULL,
	[AutorizacionObligatoria] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DeactivatedDate] [datetime] NULL,
	[DeactivatedBy] [int] NULL,
	[LastModifiedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[LastModifiedFromPCName] [varchar](64) NOT NULL,
 CONSTRAINT [PK_ConceptosNivelAutorizador] PRIMARY KEY CLUSTERED 
(
	[ConceptoId] ASC,
	[NivelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] ADD  CONSTRAINT [DF_CatConceptosNivelAutorizador_AutorizacionObligatoria]  DEFAULT ((0)) FOR [AutorizacionObligatoria]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] ADD  CONSTRAINT [DF_CatConceptosNivelAutorizador_Active]  DEFAULT ((1)) FOR [Active]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] ADD  CONSTRAINT [DF_CatConceptosNivelAutorizador_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] ADD  CONSTRAINT [DF_CatConceptosNivelAutorizador_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] ADD  CONSTRAINT [DF_CatConceptosNivelAutorizador_LastModifiedBy]  DEFAULT ((0)) FOR [LastModifiedBy]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] ADD  CONSTRAINT [DF_CatConceptosNivelAutorizador_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO

ALTER TABLE [app620].[CatConceptosNivelAutorizador] ADD  CONSTRAINT [DF_CatConceptosNivelAutorizador_LastModifiedFromPCName]  DEFAULT (host_name()) FOR [LastModifiedFromPCName]
GO


