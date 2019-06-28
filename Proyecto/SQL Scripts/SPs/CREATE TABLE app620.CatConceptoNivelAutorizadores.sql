USE [ASN]
GO

ALTER TABLE [app620].[CatConceptosAutorizadores] DROP CONSTRAINT [DF_CatConceptosAutorizadores_LastModifiedFromPCName]
GO

ALTER TABLE [app620].[CatConceptosAutorizadores] DROP CONSTRAINT [DF_CatConceptosAutorizadores_LastModifiedDate]
GO

ALTER TABLE [app620].[CatConceptosAutorizadores] DROP CONSTRAINT [DF_CatConceptosAutorizadores_LastModifiedBy]
GO

ALTER TABLE [app620].[CatConceptosAutorizadores] DROP CONSTRAINT [DF_CatConceptosAutorizadores_CreatedDate]
GO

ALTER TABLE [app620].[CatConceptosAutorizadores] DROP CONSTRAINT [DF_CatConceptosAutorizadores_CreatedBy]
GO

ALTER TABLE [app620].[CatConceptosAutorizadores] DROP CONSTRAINT [DF_CatConceptosAutorizadores_Active]
GO

/****** Object:  Table [app620].[CatConceptosAutorizadores]    Script Date: 26/06/2019 04:53:58 p. m. ******/
DROP TABLE [app620].[CatConceptosAutorizadores]
GO

/****** Object:  Table [app620].[CatConceptosAutorizadores]    Script Date: 26/06/2019 04:53:58 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[CatConceptoNivelAutorizadores](
	[ConceptoId] [int] NOT NULL,
	[NivelId] [int] NOT NULL,
	[AutorizadorIdent] [int] NOT NULL,
	[AutorizadorObligatoria] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DeactivatedDate] [datetime] NULL,
	[DeactivatedBy] [int] NULL,
	[LastModifiedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[LastModifiedFromPCName] [varchar](64) NOT NULL,
 CONSTRAINT [PK_ConceptoNivelAutorizadores] PRIMARY KEY CLUSTERED 
(
	[ConceptoId] ASC,
	[NivelId] ASC,
	[AutorizadorIdent] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [app620].[CatConceptoNivelAutorizadores] ADD  CONSTRAINT [DF_CatConceptoNivelAutorizadores_Active]  DEFAULT ((1)) FOR [Active]
GO

ALTER TABLE [app620].[CatConceptoNivelAutorizadores] ADD  CONSTRAINT [DF_CatConceptoNivelAutorizadores_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO

ALTER TABLE [app620].[CatConceptoNivelAutorizadores] ADD  CONSTRAINT [DF_CatConceptoNivelAutorizadores_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [app620].[CatConceptoNivelAutorizadores] ADD  CONSTRAINT [DF_CatConceptoNivelAutorizadores_LastModifiedBy]  DEFAULT ((0)) FOR [LastModifiedBy]
GO

ALTER TABLE [app620].[CatConceptoNivelAutorizadores] ADD  CONSTRAINT [DF_CatConceptoNivelAutorizadores_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO

ALTER TABLE [app620].[CatConceptoNivelAutorizadores] ADD  CONSTRAINT [DF_CatConceptoNivelAutorizadores_LastModifiedFromPCName]  DEFAULT (host_name()) FOR [LastModifiedFromPCName]
GO


