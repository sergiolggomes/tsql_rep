-- =============================================
-- Author:		Sergio Gomes
-- Create date: 20 Nov 2018
-- Description:	Conta tabelas em Databases MSSQL
-- =============================================

ALTER PROCEDURE NCONTABASES AS

DECLARE @BASES VARCHAR(100)
DECLARE @CBASES CURSOR
DECLARE @CMD VARCHAR(150)

CREATE TABLE #TBASES (BASE VARCHAR(50), TABELAS INT)

SET @CBASES = CURSOR FOR

SELECT name FROM SYS.DATABASES --Lista databases

OPEN @CBASES

WHILE 1=1

BEGIN 
	
	FETCH NEXT
	FROM @CBASES INTO @BASES
	IF @@FETCH_STATUS < 0 BREAK

	SET @CMD = 'USE '+@BASES
	SET @CMD = @CMD + ' 
	SELECT '''+@BASES+''', COUNT(*) AS '+@BASES+' FROM SYS.TABLES'
	--PRINT @CMD
	--EXEC (@CMD)
	INSERT INTO #TBASES EXEC (@CMD) --Acumula os dados do cursor @CBASES

END
SELECT * FROM #TBASES -- Gera a lista
CLOSE @CBASES
DEALLOCATE @CBASES

--EXEC NCONTABASES
