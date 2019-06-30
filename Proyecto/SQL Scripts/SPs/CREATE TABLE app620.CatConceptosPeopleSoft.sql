USE [ASN]
GO

ALTER TABLE [app620].[CatConceptosPeopleSoft] DROP CONSTRAINT [DF_CatConceptosPeopleSoft_LastModifiedFromPCName]
GO

ALTER TABLE [app620].[CatConceptosPeopleSoft] DROP CONSTRAINT [DF_CatConceptosPeopleSoft_LastModifiedDate]
GO

ALTER TABLE [app620].[CatConceptosPeopleSoft] DROP CONSTRAINT [DF_CatConceptosPeopleSoft_LastModifiedBy]
GO

ALTER TABLE [app620].[CatConceptosPeopleSoft] DROP CONSTRAINT [DF_CatConceptosPeopleSoft_CreatedDate]
GO

ALTER TABLE [app620].[CatConceptosPeopleSoft] DROP CONSTRAINT [DF_CatConceptosPeopleSoft_CreatedBy]
GO

ALTER TABLE [app620].[CatConceptosPeopleSoft] DROP CONSTRAINT [DF_CatConceptosPeopleSoft_Active]
GO

/****** Object:  Table [app620].[CatConceptosPeopleSoft]    Script Date: 28/06/2019 02:03:40 p. m. ******/
DROP TABLE [app620].[CatConceptosPeopleSoft]
GO

/****** Object:  Table [app620].[CatConceptosPeopleSoft]    Script Date: 28/06/2019 02:03:40 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[CatConceptosPeopleSoft](
	[ConceptoId] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
	[TipoConceptoId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DeactivatedDate] [datetime] NULL,
	[DeactivatedBy] [int] NULL,
	[LastModifiedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[LastModifiedFromPCName] [varchar](64) NOT NULL,
 CONSTRAINT [PK_ConceptosPeopleSoft] PRIMARY KEY CLUSTERED 
(
	[ConceptoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [app620].[CatConceptosPeopleSoft] ADD  CONSTRAINT [DF_CatConceptosPeopleSoft_Active]  DEFAULT ((1)) FOR [Active]
GO

ALTER TABLE [app620].[CatConceptosPeopleSoft] ADD  CONSTRAINT [DF_CatConceptosPeopleSoft_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO

ALTER TABLE [app620].[CatConceptosPeopleSoft] ADD  CONSTRAINT [DF_CatConceptosPeopleSoft_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [app620].[CatConceptosPeopleSoft] ADD  CONSTRAINT [DF_CatConceptosPeopleSoft_LastModifiedBy]  DEFAULT ((0)) FOR [LastModifiedBy]
GO

ALTER TABLE [app620].[CatConceptosPeopleSoft] ADD  CONSTRAINT [DF_CatConceptosPeopleSoft_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO

ALTER TABLE [app620].[CatConceptosPeopleSoft] ADD  CONSTRAINT [DF_CatConceptosPeopleSoft_LastModifiedFromPCName]  DEFAULT (host_name()) FOR [LastModifiedFromPCName]
GO


