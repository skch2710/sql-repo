SELECT * FROM file_upload.file_upload;

TRUNCATE TABLE file_upload.file_upload RESTART IDENTITY;

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

ALTER TABLE IF EXISTS file_upload.file_upload
ADD COLUMN IF NOT EXISTS created_by_id BIGINT DEFAULT NULL;

ALTER TABLE IF EXISTS file_upload.file_upload
ALTER COLUMN created_by_id DROP NOT NULL;

select * from emp.employees;

ALTER TABLE emp.employees
ADD emp_type_id BIGINT DEFAULT NULL;

ALTER TABLE file_upload.file_upload
ADD test VARCHAR(50) DEFAULT NULL;

/** DROP COLUMN 
  --> First DROP ForenKey Contraint Dependent DATA then DROP COlumn 

  ALTER TABLE table_name DROP COLUMN column_name;
*/

-- Drop the column after dropping the constraint
ALTER TABLE file_upload.file_upload
DROP COLUMN test;

-- Find the sequence name
SELECT pg_get_serial_sequence('hostel.users', 'user_id');

-- Drop the sequence (assuming the sequence name is 'example_table_id_seq')
DROP SEQUENCE hostel.users_user_id_seq;


ALTER TABLE hostel.users
  ALTER COLUMN user_id DROP IDENTITY;

ALTER TABLE hostel.users 
	ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY;


------------------------------------------ 

select f.file_id,f.file_name , e.email_id,e.first_name || ' ' || e.last_name AS full_name
from file_upload.file_upload f left join login.employees e on f.created_by_id = e.emp_id;

/**  SELF JOIN TABLE */
SELECT
    e1.emp_id,
    e1.email_id,
    CONCAT(e1.first_name, ' ', e1.last_name) AS full_name,
    e2.email_id AS created_by
FROM
    login.employees e1
LEFT JOIN
    login.employees e2 ON e1.created_by_id = e2.emp_id;



------- CTE Example

WITH CTE1 AS (
    SELECT column1, column2
    FROM table1
    WHERE condition1
),
CTE2 AS (
    SELECT column3, column4
    FROM table2
    WHERE condition2
)
SELECT CTE1.column1, CTE1.column2, CTE2.column3, CTE2.column4
FROM CTE1
JOIN CTE2 ON CTE1.column1 = CTE2.column3;



