-- =============================================
-- Author:		Sergio Gomes
-- Create date: 06 Abr 2022
-- Description:	Listar Logins MSSQL
-- =============================================
DECLARE @RLOGIN VARCHAR(100)
DECLARE @CLOGINS CURSOR
DECLARE @CMD VARCHAR(150)
CREATE TABLE #LOGINS (account_name VARCHAR(50), type VARCHAR(20),privilege VARCHAR(50),mapped VARCHAR(50),permission VARCHAR(50))
SET @CLOGINS = CURSOR FOR
select s.loginname from sys.syslogins s order by s.loginname--Logins list
OPEN @CLOGINS
WHILE 1=1
BEGIN
	BEGIN TRY
	FETCH  NEXT
	FROM @CLOGINS INTO @RLOGIN
	IF @@FETCH_STATUS < 0 BREAK

	SET @CMD = 'EXEC xp_logininfo '''+@RLOGIN+''',''members''';
	--PRINT @CMD
	INSERT INTO #LOGINS EXEC (@CMD); -- Create Logins temp table
	END TRY
	BEGIN CATCH
		INSERT INTO #LOGINS VALUES(@RLOGIN,NULL,NULL,NULL,NULL);
	END CATCH
END
SELECT permission,account_name,mapped,type,privilege FROM #LOGINS ORDER BY permission,account_name
CLOSE @CLOGINS
DEALLOCATE @CLOGINS
DROP TABLE #LOGINS
