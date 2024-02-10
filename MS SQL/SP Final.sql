
--USE mydb;

/** =============================================
-- Author	  :	Ch Sathish Kumar
-- Create date: 12-29-2023
-- Description:	Employee Get Data SP

-- EXEC SCRIPT :

EXEC [login].[GetEmployeeDataEmpty] @In_EmpId = '' ,@In_EmpRoleId = '' ,@In_EmailId = 'sk',@In_FirstName = '',
@In_CreatedDate = '', @In_SortBy = 'emp_id' , @In_SortOrder ='asc' ,@In_PageNumber =1 ,@In_PageSize = 25,
@In_IsExport = 0 , @Clf_LastName = '' ,@Clf_ModifiedDate = '';

-- EmpId Single selection , EmpRoleId multi selectio , Email StartWith

 ============================================= **/
CREATE OR ALTER PROCEDURE [login].[GetEmployeeDataEmpty]( 
    -- Add the parameters for the stored procedure here
    @In_EmpId BIGINT = NULL,
    @In_EmpRoleId VARCHAR(250) = NULL,
    @In_EmailId VARCHAR(250) = '',
    @In_FirstName VARCHAR(250) = '',
    @In_CreatedDate DATE = NULL,
    @In_SortBy NVARCHAR(50) = 'id',
    @In_SortOrder NVARCHAR(10) = 'ASC',
    @In_PageNumber INT = 1,
    @In_PageSize INT = 25,
    @In_IsExport BIT = 0,
    @Clf_LastName NVARCHAR(100) = NULL,
    @Clf_ModifiedDate NVARCHAR(20) = NULL
) AS
BEGIN
    -- Create the temporary result set table
    DROP TABLE IF EXISTS #TempResult;

    -- Execute the main query to populate the temporary result set
    SELECT e.emp_id,
           e.email_id,
           e.first_name,
           e.last_name,
           e.created_by_id,
           er.emp_role_id,
           r.role_id,
           r.role_name,
           r.is_external_role,
           e.created_date,
           e.modified_date,
           'SATHISH' AS owner_name,
           CAST('1996-10-27' AS DATE) AS owner_dob
		   INTO #TempResult
    FROM login.employees e 
    LEFT JOIN login.emp_roles er ON e.emp_id = er.emp_id 
    LEFT JOIN login.roles r ON r.role_id = er.role_id
    WHERE 
		(e.emp_id = @In_EmpId OR ISNULL(@In_EmpId, 0) = 0) 
		AND (er.emp_role_id IN (SELECT CAST(VALUE AS BIGINT) FROM STRING_SPLIT(@In_EmpRoleId, ',')) OR @In_EmpRoleId = '')
		AND (CAST(e.created_date AS DATE) = @In_CreatedDate OR @In_CreatedDate ='')
		AND (@In_EmailId = '' OR e.email_id LIKE @In_EmailId + '%')
        AND (e.first_name IN (SELECT CAST(VALUE AS VARCHAR) FROM STRING_SPLIT(@In_FirstName, ',')) OR @In_FirstName = '')
	 ;

    -- Construct the SQL statement for further filtering and pagination
    DECLARE @sqlstmnt NVARCHAR(MAX),
            @orderbyclause NVARCHAR(500);

    SET @sqlstmnt = 'SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS id,*,
           COUNT(1) OVER (PARTITION BY 1) AS totalRows FROM #TempResult WHERE 1=1';

    -- Apply additional filters based on parameters
    IF ISNULL(@Clf_LastName, '') <> ''
        SET @sqlstmnt = @sqlstmnt + ' AND [last_name] LIKE @Clf_LastName + ''%''';

    IF ISNULL(@Clf_ModifiedDate, '') <> ''
        SET @sqlstmnt = @sqlstmnt + ' AND CAST(modified_date AS DATE) = @Clf_ModifiedDate';

    -- Construct the ORDER BY clause
    SET @orderbyclause = ' ORDER BY ' + QUOTENAME(@In_SortBy) + ' ' + @In_SortOrder;
	
	SET @sqlstmnt = @sqlstmnt + @orderbyclause;

    -- If export is not required, apply pagination
    IF @In_IsExport = 0
		BEGIN
			SET @sqlstmnt = @sqlstmnt + ' OFFSET @In_PageSize * (@In_PageNumber -1) ROWS FETCH NEXT @In_PageSize ROWS ONLY'
		END
	
	PRINT @sqlstmnt

    -- Execute the constructed SQL statement
    EXEC sp_executesql @sqlstmnt,
                       N'@Clf_LastName VARCHAR(100),
                         @Clf_ModifiedDate VARCHAR(20),
                         @In_PageNumber INT,
                         @In_PageSize INT',
                       @Clf_LastName = @Clf_LastName,
                       @Clf_ModifiedDate = @Clf_ModifiedDate,
                       @In_PageNumber = @In_PageNumber,
                       @In_PageSize = @In_PageSize;
END
