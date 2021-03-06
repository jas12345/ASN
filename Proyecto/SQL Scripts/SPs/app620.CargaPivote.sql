USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CargaPivote]    Script Date: 19/04/2019 11:21:46 a. m. ******/
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

ALTER PROCEDURE [app620].[CargaPivote] 
	@Consecutivo INT
AS
BEGIN
	DELETE FROM app620.Foo;

	INSERT INTO app620.Foo VALUES('0')
	INSERT INTO app620.Foo VALUES('1')
	INSERT INTO app620.Foo VALUES('2')
	INSERT INTO app620.Foo VALUES('3')
	INSERT INTO app620.Foo VALUES('4')
	INSERT INTO app620.Foo VALUES('5')
	INSERT INTO app620.Foo VALUES('6')
	INSERT INTO app620.Foo VALUES('7')
	INSERT INTO app620.Foo VALUES('8')
	INSERT INTO app620.Foo VALUES('9')

	DELETE FROM app620.Pivote;
	IF (@Consecutivo > 100) 
		BEGIN
			INSERT INTO app620.Pivote
			SELECT f1.i+f2.i+f3.i, f1.i+f2.i+f3.i
			FROM app620.Foo f1, app620.Foo F2, app620.Foo f3
		END
	ELSE IF (@Consecutivo > 10) 
		BEGIN
			INSERT INTO app620.Pivote
			SELECT f1.i+f2.i, f1.i+f2.i
			FROM app620.Foo f1, app620.Foo F2
		END
	ELSE
		BEGIN
			INSERT INTO app620.Pivote
			SELECT f1.i, f1.i
			FROM app620.Foo f1
		END
END

