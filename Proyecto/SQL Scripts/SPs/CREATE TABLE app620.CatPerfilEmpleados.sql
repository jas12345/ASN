USE [ASN]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] DROP CONSTRAINT [DF_CatPerfilEmpleados_LastModifiedFromPCName]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] DROP CONSTRAINT [DF_CatPerfilEmpleados_LastModifiedDate]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] DROP CONSTRAINT [DF_CatPerfilEmpleados_LastModifiedBy]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] DROP CONSTRAINT [DF_CatPerfilEmpleados_CreatedDate]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] DROP CONSTRAINT [DF_CatPerfilEmpleados_CreatedBy]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] DROP CONSTRAINT [DF_CatPerfilEmpleados_Active]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] DROP CONSTRAINT [DF_CatPerfilEmpleados_TipoAccesoId]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] DROP CONSTRAINT [DF_CatPerfilEmpleados_NombrePerfilEmpleados]
GO

/****** Object:  Table [app620].[CatPerfilEmpleados]    Script Date: 03/05/2019 01:52:50 p. m. ******/
DROP TABLE [app620].[CatPerfilEmpleados]
GO

/****** Object:  Table [app620].[CatPerfilEmpleados]    Script Date: 03/05/2019 01:52:50 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[CatPerfilEmpleados](
	[Perfil_Ident] [int] IDENTITY(1,1) NOT NULL,
	[NombrePerfilEmpleados] [varchar](50) NOT NULL,
	[Country_Ident] [int] NULL,
	[City_Ident] [int] NULL,
	[Company_Ident] [int] NULL,
	[Location_Ident] [int] NULL,
	[Client_Ident] [int] NULL,
	[Program_Ident] [int] NULL,
	[Contract_Type_Ident] [int] NULL,
	[ConceptoId] [int] NULL,
	[TipoAccesoId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DeactivatedDate] [datetime] NULL,
	[DeactivatedBy] [int] NULL,
	[LastModifiedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[LastModifiedFromPCName] [varchar](64) NOT NULL,
 CONSTRAINT [PK_Perfil] PRIMARY KEY CLUSTERED 
(
	[Perfil_Ident] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] ADD  CONSTRAINT [DF_CatPerfilEmpleados_NombrePerfilEmpleados]  DEFAULT ('0') FOR [NombrePerfilEmpleados]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] ADD  CONSTRAINT [DF_CatPerfilEmpleados_TipoAccesoId]  DEFAULT ((1)) FOR [TipoAccesoId]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] ADD  CONSTRAINT [DF_CatPerfilEmpleados_Active]  DEFAULT ((1)) FOR [Active]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] ADD  CONSTRAINT [DF_CatPerfilEmpleados_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] ADD  CONSTRAINT [DF_CatPerfilEmpleados_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] ADD  CONSTRAINT [DF_CatPerfilEmpleados_LastModifiedBy]  DEFAULT ((0)) FOR [LastModifiedBy]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] ADD  CONSTRAINT [DF_CatPerfilEmpleados_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO

ALTER TABLE [app620].[CatPerfilEmpleados] ADD  CONSTRAINT [DF_CatPerfilEmpleados_LastModifiedFromPCName]  DEFAULT (host_name()) FOR [LastModifiedFromPCName]
GO


