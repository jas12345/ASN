USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[TraCommentSel]    Script Date: 23/08/2019 04:34:20 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[TraCommentSel]
@FolioId int, -- El Id del Folio
@EID int, --EL employeeId al que le esta haciendo el movimiento
@ConceptoId int -- EL conceptoId del registro
AS
BEGIN
	SELECT 
		a.TraCommentId
		,a.Comment As Comentario
		,a.FolioId
		,a.CreatedDate AS FechaComentario
		,CASE WHEN c.Middle_Name IS NULL OR LEN(c.Middle_Name) = 0 THEN c.First_Name + ' ' + c.Last_Name ELSE c.First_Name + ' ' + isnull(c.Middle_Name,'') + ' ' + c.Last_Name END AS Nombre
		,a.CreatedBy AS CCMSIDAutor
		,0 AS EmployeeId
		,0 AS ConceptoId
	FROM [app620].[TraComment] a
	INNER JOIN [app620].[CatEmployeeCCMSVw] c on a.CreatedBy = c.Ident
	WHERE 
	a.FolioId = @FolioId
	AND
	a.EmployeeId = @EID
	AND
	a.ConceptoId = @ConceptoId
	order by a.CreatedDate desc
END
