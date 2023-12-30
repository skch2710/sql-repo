--USE mydb;

/** =============================================
-- Author	  :	Ch Sathish Kumar
-- Create date: 12-29-2023
-- Description:	Employee Get Data SP

-- EXEC SCRIPT :

EXEC [login].[GetEmployeeData] @In_EmpId = '' ,@In_EmpRoleId = '' ,@In_EmailId = '',@In_FirstName = '',
@In_CreatedDate = '', @In_SortBy = 'emp_id' , @In_SortOrder ='asc' ,@In_PageNumber =1 ,@In_PageSize = 25,
@In_IsExport = 0 , @Clf_LastName = '' ,@Clf_ModifiedDate = ''

-- EmpId Single selection , EmpRoleId multi selectio , Email StartWith

 ============================================= **/
CREATE OR ALTER PROCEDURE [login].[GetEmployeeData]( 
	-- Add the parameters for the stored procedure here
	@In_EmpId BIGINT = NULL,
	@In_EmpRoleId VARCHAR(250) = NULL,
	@In_EmailId VARCHAR(250) = NULL,
	@In_FirstName VARCHAR(250) = NULL,
	@In_CreatedDate DATE = NULL,
	@In_SortBy VARCHAR(50) = 'id',
	@In_SortOrder VARCHAR(10) = 'ASC',
	@In_PageNumber INT = 1,
	@In_PageSize INT = 25,
	@In_IsExport BIT = 0,
	@Clf_LastName VARCHAR(100) = NULL,
	@Clf_ModifiedDate VARCHAR(20) = NULL

) AS
BEGIN
	DROP TABLE IF EXISTS #TempResult;

	DECLARE @Dv_EmpId BIGINT = NULL,
	@Dv_EmpRoleId VARCHAR(250) = NULL,
	@Dv_EmailId VARCHAR(250) = NULL,
	@Dv_FirstName VARCHAR(250) = NULL,
	@Dv_CreatedDate DATE,
	@Dv_SortBy VARCHAR(100),
	@Dv_SortOrder VARCHAR(100),
	@Dv_PageNumber INT,
	@Dv_PageSize INT,
	@Dv_IsExport BIT = 0,
	@sqlstmnt NVARCHAR(MAX),
	@orderbyclause NVARCHAR(500) = ''

	SELECT @Dv_EmpId = @In_EmpId, @Dv_EmpRoleId = @In_EmpRoleId ,
	@Dv_EmailId = @In_EmailId , @Dv_FirstName = @In_FirstName,@Dv_CreatedDate = ISNULL(@In_CreatedDate,'') ,
	@Dv_SortBy = CASE WHEN @In_SortBy = '' THEN 'id' ELSE @In_SortBy END,
	@Dv_SortOrder = CASE WHEN @In_SortOrder = '' THEN 'ASC' ELSE @In_SortOrder END,
	@Dv_PageNumber = @In_PageNumber , @Dv_PageSize = @In_PageSize, @Dv_IsExport = @In_IsExport

	SELECT ROW_NUMBER() over(order by (select 1)) id,
	e.emp_id,e.email_id,e.first_name,e.last_name,
	e.created_by_id,er.emp_role_id,r.role_id,r.role_name,r.is_external_role,
	e.created_date,e.modified_date,
	'SATHISH' AS owner_name, CAST('1996-10-27' AS DATE) AS owner_dob 
	INTO #TempResult
	FROM login.employees e LEFT JOIN login.emp_roles er ON e.emp_id=er.emp_id 
	LEFT JOIN login.roles r ON r.role_id = er.role_id
	WHERE (e.emp_id = @Dv_EmpId OR ISNULL(@Dv_EmpId,0)=0) AND 
	(er.emp_role_id IN (SELECT CAST(VALUE AS BIGINT) FROM STRING_SPLIT(@Dv_EmpRoleId,',')) OR @Dv_EmpRoleId='')
	AND (CAST(e.created_date AS DATE) = @Dv_CreatedDate OR @Dv_CreatedDate = '')
	AND (e.email_id LIKE @Dv_EmailId + '%') AND 
	(e.first_name IN (SELECT CAST(VALUE AS VARCHAR) FROM STRING_SPLIT(@Dv_FirstName,',')) OR @Dv_FirstName='')

	SET @sqlstmnt = 'SELECT * FROM #TempResult WHERE 1=1 '

	--clf -- Column Level Filter Here
	IF ISNULL(@Clf_LastName,'') <> ''
		SET @sqlstmnt = @sqlstmnt + ' AND [last_name] like + @Clf_LastName + ''%'''
	IF ISNULL(@Clf_ModifiedDate,'') <> ''
		SET @sqlstmnt = @sqlstmnt + ' AND CAST(modified_date AS DATE) = @Clf_ModifiedDate '

	SET @orderbyclause = 'ORDER BY '+ QUOTENAME(@Dv_SortBy) + ' ' + @Dv_SortOrder

	IF @Dv_IsExport = 0
		BEGIN
			SET @sqlstmnt = 'SELECT *,COUNT(1) OVER (PARTITION BY 1) AS totalRows FROM (' + @sqlstmnt + ')TMP ' + @orderbyclause
			SET @sqlstmnt = @sqlstmnt + ' OFFSET @Dv_PageSize * (@Dv_PageNumber -1) ROWS FETCH NEXT @Dv_PageSize ROWS ONLY'
		END
	ELSE
		BEGIN
			SET @sqlstmnt = 'SELECT *,COUNT(1) OVER (PARTITION BY 1) AS totalRows FROM (' + @sqlstmnt + ')TMP ' + @orderbyclause
		END
	
	PRINT @sqlstmnt

	EXEC sp_executesql @sqlstmnt,
	N'@Dv_PageNumber INT,
	@Dv_PageSize INT,
	@Clf_LastName VARCHAR(100),
	@Clf_ModifiedDate VARCHAR(100)',

	@Dv_PageNumber = @Dv_PageNumber,
	@Dv_PageSize = @Dv_PageSize,
	@Clf_LastName = @Clf_LastName,
	@Clf_ModifiedDate = @Clf_ModifiedDate;

END
GO
