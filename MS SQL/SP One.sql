
--EXEC [login].[GetEmpty]

CREATE OR ALTER PROCEDURE [login].[GetEmpty]
AS
BEGIN
    -- Create the temporary result set table
    DROP TABLE IF EXISTS #TempResult;
	CREATE TABLE #TempResult (
        email_id VARCHAR(250)
    );
	 -- Construct the SQL statement for further filtering and pagination
    DECLARE @sqlstmnt NVARCHAR(MAX);

	INSERT INTO #TempResult VALUES ('SA'),('skch');

    SET @sqlstmnt = 'SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS id,email_id,
           COUNT(1) OVER (PARTITION BY 1) AS totalRows FROM #TempResult WHERE 1=1';
	PRINT @sqlstmnt

    -- Execute the constructed SQL statement
    EXEC sp_executesql @sqlstmnt;
END



CREATE OR ALTER PROCEDURE [login].[GetEmpty1]
AS
BEGIN
    -- Create the temporary result set table
    DROP TABLE IF EXISTS #TempResult;
	
	 -- Construct the SQL statement
    DECLARE @sqlstmnt NVARCHAR(MAX);

	SELECT e.email_id INTO #TempResult FROM login.employees e ;

    SET @sqlstmnt = 'SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS id,email_id,
           COUNT(1) OVER (PARTITION BY 1) AS totalRows FROM #TempResult WHERE 1=1';
	PRINT @sqlstmnt

    -- Execute the constructed SQL statement
    EXEC sp_executesql @sqlstmnt;
END

-- EXEC [login].[GetEmpty2] @In_EmpId = '1';

CREATE OR ALTER PROCEDURE [login].[GetEmpty2](
@In_EmpId BIGINT = NULL
)
AS
BEGIN
    -- Create the temporary result set table
    DROP TABLE IF EXISTS #TempResult;
	
	 -- Construct the SQL statement
    DECLARE @sqlstmnt NVARCHAR(MAX);

	SELECT e.email_id,e.emp_id INTO #TempResult FROM login.employees e 
	WHERE (e.emp_id = @In_EmpId OR ISNULL(@In_EmpId, 0) = 0) ;

    SET @sqlstmnt = 'SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS id,emp_id,email_id,
           COUNT(1) OVER (PARTITION BY 1) AS totalRows FROM #TempResult WHERE 1=1';
	PRINT @sqlstmnt

    -- Execute the constructed SQL statement
    EXEC sp_executesql @sqlstmnt;
END