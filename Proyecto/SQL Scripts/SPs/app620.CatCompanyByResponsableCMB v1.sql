USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatCompanyByResponsableCMB]    Script Date: 9/21/2020 11:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [app620].[CatCompanyByResponsableCMB]
@CCMSID INT
       AS
              BEGIN

                     SELECT C.ID_Empresa,C.CIA_IDReporteo Empresa
                     FROM   app620.CatPerfilEmpleadosAccesos PEA WITH(NOLOCK)
                                  INNER JOIN app620.CatPerfilEmpleados PE WITH(NOLOCK) ON PEA.Perfil_Ident = PE.Perfil_Ident
                                  INNER JOIN app620.CatIdEmpresaXCCMSContractVw C WITH(NOLOCK) ON C.Contract_Type_Ident = PE.Contract_Type_Ident

                                  ----Adecuación de MultiCliente en RelPerfilEmpleadosClientes (Responsables)
                                  INNER JOIN    app620.RelPerfilEmpleadosClientes RECliRes
                                  ON                   PEA.Perfil_Ident     = RECliRes.Perfil_Ident 
                                  AND                  (PE.Client_Ident    = RECliRes.Client_Ident  or RECliRes.Client_Ident = '-1')

                     WHERE  PEA.EmpleadoId=@CCMSID AND
                                  PE.TipoAccesoId = 3
              END
