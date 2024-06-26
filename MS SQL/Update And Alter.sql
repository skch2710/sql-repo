SELECT * FROM [file_upload].[file_upload];

/** 
UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;
*/
UPDATE [file_upload].[file_upload] SET [created_by_id] = 1 WHERE file_id in (1,2);

/** 
		ALTER TABLE table_name
		ADD column1_name data_type1 DEFAULT NULL;,
		ADD column2_name data_type2,
		...;
 */

ALTER TABLE [file_upload].[file_upload]
ADD [created_by_id] BIGINT DEFAULT NULL;

ALTER TABLE [file_upload].[file_upload]
ADD [test] VARCHAR(50) DEFAULT NULL;

/** DROP COLUMN 
  --> First DROP ForenKey Contraint Dependent DATA then DROP COlumn 

  ALTER TABLE table_name DROP COLUMN column_name;
*/

-- Drop the default constraint
ALTER TABLE [file_upload].[file_upload]
DROP CONSTRAINT DF__file_uploa__test__6EF57B66;

-- Drop the column after dropping the constraint
ALTER TABLE [file_upload].[file_upload]
DROP COLUMN test;

-- Enable identity insert
SET IDENTITY_INSERT emp.employees ON;

-- Disable identity insert
SET IDENTITY_INSERT emp.employees OFF;

------------------------------------------ 

select f.file_id,f.file_name , e.email_id,e.first_name+' '+e.last_name AS full_name
from [file_upload].[file_upload] f left join [login].[employees] e on f.created_by_id = e.emp_id;

/**  SELF JOIN TABLE */
select  e1.emp_id, e1.email_id,e1.first_name+' '+e1.last_name AS full_name ,e2.email_id AS Created_By
from [login].[employees] e1 left join [login].[employees] e2 on e1.created_by_id = e2.emp_id;
