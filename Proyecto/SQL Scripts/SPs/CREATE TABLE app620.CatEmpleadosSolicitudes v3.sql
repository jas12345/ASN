USE [ASN]
GO

ALTER TABLE [app620].[CatEmpleadosSolicitudes] DROP CONSTRAINT [DF_CatEmpleadosSolicitudes_LastModifiedFromPCName]
GO

ALTER TABLE [app620].[CatEmpleadosSolicitudes] DROP CONSTRAINT [DF_CatEmpleadosSolicitudes_LastModifiedDate]
GO

ALTER TABLE [app620].[CatEmpleadosSolicitudes] DROP CONSTRAINT [DF_CatEmpleadosSolicitudes_LastModifiedBy]
GO

ALTER TABLE [app620].[CatEmpleadosSolicitudes] DROP CONSTRAINT [DF_CatEmpleadosSolicitudes_CreatedDate]
GO

ALTER TABLE [app620].[CatEmpleadosSolicitudes] DROP CONSTRAINT [DF_CatEmpleadosSolicitudes_CreatedBy]
GO

ALTER TABLE [app620].[CatEmpleadosSolicitudes] DROP CONSTRAINT [DF_CatEmpleadosSolicitudes_Active]
GO

/****** Object:  Table [app620].[CatEmpleadosSolicitudes]    Script Date: 14/06/2019 10:27:05 a. m. ******/
DROP TABLE [app620].[CatEmpleadosSolicitudes]
GO

/****** Object:  Table [app620].[CatEmpleadosSolicitudes]    Script Date: 14/06/2019 10:27:05 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[CatEmpleadosSolicitudes](
	[FolioSolicitud] [int] NOT NULL,
	[Empleado_Ident] [int] NOT NULL,
	[ConceptoId] [int] NOT NULL,
	--[Empleado_First_Name] [varchar](250) NOT NULL,
	--[Empleado_Middle_Name] [varchar](250) NOT NULL,
	--[Empleado_Last_Name] [varchar](250) NOT NULL,
	[Empleado_Position_Code_Ident] [int] NOT NULL,
	--[Empleado_Position_Code_Title] [varchar](150) NOT NULL,
	[Empleado_Contract_Type_Ident] [int] NOT NULL,
	--[Empleado_Contract_Type] [varchar](50) NOT NULL,
	[Manager_Ident] [int] NOT NULL,
	--[Manager_First_Name] [varchar](250) NOT NULL,
	--[Manager_Middle_Name] [varchar](250) NOT NULL,
	--[Manager_Last_Name] [varchar](250) NOT NULL,
	[Manager_Position_Code_Ident] [int] NOT NULL,
	--[Manager_Position_Code_Title] [varchar](150) NOT NULL,
	[Manager_Contract_Type_Ident] [int] NOT NULL,
	--[Manager_Contract_Type] [varchar](50) NOT NULL,
	[ParametroConceptoMonto] [decimal](18, 2) NULL,
	[Detalle] [varchar](250) NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DeactivatedBy] [int] NULL,
	[DeactivatedDate] [datetime] NULL,
	[LastModifiedBy] [int] NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[LastModifiedFromPCName] [varchar](64) NOT NULL,
 CONSTRAINT [PK_RelEmpleadosSolicitudes] PRIMARY KEY CLUSTERED 
(
	[FolioSolicitud] ASC,
	[Empleado_Ident] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [app620].[CatEmpleadosSolicitudes] ADD  CONSTRAINT [DF_CatEmpleadosSolicitudes_Active]  DEFAULT ((1)) FOR [Active]
GO

ALTER TABLE [app620].[CatEmpleadosSolicitudes] ADD  CONSTRAINT [DF_CatEmpleadosSolicitudes_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO

ALTER TABLE [app620].[CatEmpleadosSolicitudes] ADD  CONSTRAINT [DF_CatEmpleadosSolicitudes_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [app620].[CatEmpleadosSolicitudes] ADD  CONSTRAINT [DF_CatEmpleadosSolicitudes_LastModifiedBy]  DEFAULT ((0)) FOR [LastModifiedBy]
GO

ALTER TABLE [app620].[CatEmpleadosSolicitudes] ADD  CONSTRAINT [DF_CatEmpleadosSolicitudes_LastModifiedDate]  DEFAULT (getdate()) FOR [LastModifiedDate]
GO

ALTER TABLE [app620].[CatEmpleadosSolicitudes] ADD  CONSTRAINT [DF_CatEmpleadosSolicitudes_LastModifiedFromPCName]  DEFAULT (host_name()) FOR [LastModifiedFromPCName]
GO


