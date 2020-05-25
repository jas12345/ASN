USE ASN_PE
go

BEGIN TRAN

SELECT Client_Ident, *
FROM app620.CatPerfilEmpleados

UPDATE [app620].[CatPerfilEmpleados]
SET Client_Ident = NULL

SELECT Client_Ident, *
FROM app620.CatPerfilEmpleados

ROLLBACK TRAN
--COMMIT TRAN