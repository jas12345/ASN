USE [ASN]
GO
/****** Object:  StoredProcedure [dbo].[CargaPivote]    Script Date: 06/04/2019 11:25:51 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----CREATE TABLE Pivote (
----   i INT,
----   iVarChar VARCHAR(10),
----   PRIMARY KEY(i)
----)
--SELECT * FROM Pivote

----CREATE TABLE Foo(
----   i CHAR(1)
----)

--INSERT INTO Foo VALUES('0')
--INSERT INTO Foo VALUES('1')
--INSERT INTO Foo VALUES('2')
--INSERT INTO Foo VALUES('3')
--INSERT INTO Foo VALUES('4')
--INSERT INTO Foo VALUES('5')
--INSERT INTO Foo VALUES('6')
--INSERT INTO Foo VALUES('7')
--INSERT INTO Foo VALUES('8')
--INSERT INTO Foo VALUES('9')

--SELECT * FROM Foo

--INSERT INTO Pivote
--   SELECT f1.i+f2.i+f3.i, f1.i+f2.i+f3.i
--   FROM Foo f1, Foo F2, Foo f3


--   SELECT f1.i+f2.i, f1.i+f2.i
--   FROM Foo f1, Foo F2
--   ORDER BY f1.i+f2.i


CREATE PROCEDURE [app620].[CargaPivote] 
	@Consecutivo INT
AS
BEGIN
	DELETE FROM Pivote;
	IF (@Consecutivo > 100) 
		BEGIN
			INSERT INTO Pivote
			SELECT f1.i+f2.i+f3.i, f1.i+f2.i+f3.i
			FROM Foo f1, Foo F2, Foo f3
		END
	ELSE IF (@Consecutivo > 10) 
		BEGIN
			INSERT INTO Pivote
			SELECT f1.i+f2.i, f1.i+f2.i
			FROM Foo f1, Foo F2
		END
	ELSE
		BEGIN
			INSERT INTO Pivote
			SELECT f1.i, f1.i
			FROM Foo f1
		END
END

