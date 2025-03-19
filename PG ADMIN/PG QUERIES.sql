--- CREATE TABLE
CREATE TABLE IF NOT EXISTS example_table (
    example_table_id BIGINT GENERATED ALWAYS AS IDENTITY, -- Auto-incrementing integer
    full_name VARCHAR(100) NOT NULL, -- Variable-length string (up to 100 characters)
    email_id VARCHAR(150) UNIQUE, -- Unique constraint
    age SMALLINT CHECK (age > 0 AND age < 120), -- Small integer with a check constraint
    dob DATE, -- Date type
    salary NUMERIC(14, 2) DEFAULT 0.00, -- Numeric type with precision and scale
    joining_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Date and time with default
    active BOOLEAN DEFAULT TRUE, -- Boolean type
    profile_picture BYTEA, -- Binary data (e.g., for images)
    bio TEXT, -- Long text
    preferences JSONB, -- JSON data type
    login_attempts INT DEFAULT 0, -- Integer with default value
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp with default value
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Auto-updating timestamp
    department_id UUID NOT NULL, -- UUID type for unique identifiers
    ip_address INET, -- IP address
    mac_address MACADDR, -- MAC address
    document XML, -- XML data type
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')), -- Single character with a check constraint
	CONSTRAINT pk_example_table_example_table_id PRIMARY KEY (example_table_id), -- Explicit PK constraint
    CONSTRAINT uk_example_table_email UNIQUE (email_id), -- Explicit unique constraint
    CONSTRAINT chk_salary CHECK (salary >= 0) -- Explicit check constraint
    --CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE -- Foreign key constraint
);

-- Temp Table

CREATE TEMP TABLE IF NOT EXISTS temp_table(
	temp_id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	temp_value VARCHAR(100)
) ON COMMIT DROP;

BEGIN;

CREATE TEMP TABLE temp_table ON COMMIT DROP AS 
SELECT * FROM hostel.hostellers;
SELECT * FROM temp_table;

COMMIT;

--- DROP --
DROP TABLE IF EXISTS temp_table;

-- TRUNCATE  --
TRUNCATE TABLE temp_table RESTART IDENTITY;

-- INSERT ---
INSERT INTO example_table (
    full_name, email_id, age, dob, salary, joining_date, active, profile_picture,
    bio, preferences, login_attempts, created_at, updated_at, department_id,
    ip_address, mac_address, document_value, gender
) VALUES ('Test three', 'testthree@example.com', 20, '2004-05-15', 20000.00, CURRENT_TIMESTAMP,
    TRUE, NULL,'A software engineer who loves coding.',
    '{"theme": "dark", "notifications": true}', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
    uuid_generate_v4(), '192.168.1.1', '08:00:27:00:4c:02',
    '<document><title>Sample</title></document>', 'M'),
	
	('Test Four', 'testrour@example.com', 45, '1993-05-15', 80000.00, CURRENT_TIMESTAMP,
    TRUE, NULL,'A software engineer who loves coding.',
    '{"theme": "dark", "notifications": true}', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
    uuid_generate_v4(), '192.168.1.1', '08:00:27:00:4c:02',
    '<document><title>Sample</title></document>', 'M');


-- Insert and return Id
WITH new_employee_id AS (
    INSERT INTO employee (first_name, last_name, email)
    VALUES ('test', 'test', 'test')
    RETURNING id
)
INSERT INTO address (employee_id, street, city, state, zip_code)
SELECT id, 'addr.street', 'addr.city', 'addr.state', 'addr.zip_code'
FROM new_employee_id;

--UPDATE
UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;


-- ALTER

ALTER TABLE IF EXISTS example_table
ADD COLUMN IF NOT EXISTS test varchar(10) DEFAULT 'Test',
ADD COLUMN IF NOT EXISTS start_date TIMESTAMP,
ADD COLUMN IF NOT EXISTS end_date TIMESTAMP;

ALTER TABLE IF EXISTS example_table 
RENAME COLUMN document TO document_value;

ALTER TABLE example_table
DROP COLUMN IF EXISTS test;

ALTER TABLE IF EXISTS example_table
ALTER COLUMN test DROP NOT NULL;

-- Find the sequence name
SELECT pg_get_serial_sequence('hostel.users', 'user_id');

ALTER TABLE example_table
  ALTER COLUMN example_table_id DROP IDENTITY;

ALTER TABLE example_table 
	ALTER COLUMN example_table_id ADD GENERATED ALWAYS AS IDENTITY;

-- SELECT 
SELECT * FROM example_table;

--- ASC NULLS LAST
select * from emp.employees ORDER BY salary ASC;
-- ASC NULLS FIRST
SELECT * FROM emp.employees ORDER BY salary ASC NULLS FIRST;
-- DESC NULLS FIRST
select * from emp.employees ORDER BY salary DESC;
-- DESC NULLS LAST
SELECT * FROM emp.employees ORDER BY salary DESC NULLS LAST;

-- DATE
SELECT NOW();
SELECT CURRENT_DATE;
SELECT CURRENT_TIMESTAMP;
SHOW TIME ZONE;

SELECT TO_DATE(NULLIF('10/20/2021',''),'MM/dd/yyyy');
SELECT TO_TIMESTAMP(NULLIF('10/20/2021',''),'MM/dd/yyyy');

SELECT CAST(NULLIF('2021-01-25','') AS DATE)
SELECT CAST(NULLIF('2021-01-25','') AS TIMESTAMP)

SELECT now() + INTERVAL '2 hours';
SELECT CURRENT_DATE + INTERVAL '10 days';
SELECT CURRENT_DATE - INTERVAL '1 month';
SELECT CURRENT_DATE + INTERVAL '5 years';
SELECT CURRENT_DATE - CONCAT('10',' days')::INTERVAL;
SELECT CURRENT_DATE + CONCAT('10',' days')::INTERVAL;

SELECT DATE_PART('day',now()-TO_DATE('21/02/2024', 'DD/MM/YYYY'));

SELECT AGE('2024-12-31', '2024-01-01');

SELECT AGE(CURRENT_DATE, '2024-10-01');

SELECT CURRENT_DATE - CAST('2024-10-06' AS DATE) AS days_difference;

SELECT (CURRENT_DATE - INTERVAL '4 days')

select * from example_table 
	WHERE (CURRENT_DATE - INTERVAL '4 days')::DATE = joining_date::DATE;

SELECT * FROM example_table
WHERE (end_date IS NULL OR (end_date > start_date AND end_date >= CURRENT_DATE));

select '2022-01-21' :: date
select '2022-01-21' :: timestamp
SELECT TO_CHAR(now(), 'MM/DD/YYYY') AS formatted_date;
SELECT TO_CHAR(CURRENT_DATE, 'DD-MM-YYYY') AS formatted_date;

--- Number Convertions
select -20 :: numeric(14,2);
SELECT '$' || TO_CHAR(14333333.49, '999,999,999.99') AS formatted_value;
SELECT '₹' || TO_CHAR(14333333.49, '99,99,99,999.99') AS formatted_value;
select ABS(-20) :: numeric(14,2);

SELECT 
  CASE 
    WHEN 20 >= 0 THEN '$' || TO_CHAR(-20, '999,999,999.99')
    ELSE '$ (' || TO_CHAR(ABS(-20), '999,999,999.99') || ')'
  END AS formatted_value;

-- CONCAT
SELECT CONCAT('a',' - ','b');

-- ROW_NUMBER , COUNT
SELECT ROW_NUMBER() OVER (ORDER BY NOW()) AS row_num;
SELECT COUNT(1) OVER() AS total_count;
SELECT COUNT(1) FROM example_table;
SELECT COUNT(email_id) FROM example_table;
SELECT COUNT(*) FROM example_table;

-- MIN , MAX , GREATEST
SELECT MIN(salary),MAX(salary),GREATEST(salary) FROM example_table;

SELECT GREATEST(created_at,updated_at,start_date) FROM example_table;

-- NULLIF
SELECT NULLIF('','');

-- CASE STATEMENT
SELECT CASE WHEN NULLIF('1','') IS NOT NULL THEN 'TRUE'
		ELSE 'FALSE' END AS null_if;

-- COALESCE
SELECT COALESCE(NULL,'b');
SELECT COALESCE('','false') <> 'false';
SELECT COALESCE(MAX(version_no),0) as max_version from file_upload.file_upload WHERE org_id=10;
SELECT COALESCE(MAX(version_no),0)+1 as max_version from file_upload.file_upload WHERE org_id=1;
SELECT COALESCE('true','false')='false';

-- IF 
DO $$
BEGIN
   IF COALESCE('a','a') <> '' THEN
      RAISE NOTICE 'TRUE';
	ELSE 
	  RAISE NOTICE 'FALSE';
   END IF;
END $$;


--- Acive Sections 
SELECT datname,pid,state,query , age(clock_timestamp(),query_start) as age
FROM pg_stat_activity WHERE state <> 'idle' ORDER BY age;

SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid in (14404);


--- Index
/* 
Indexes in PostgreSQL are a powerful feature designed to improve the speed and efficiency of database queries.
*/

CREATE INDEX idx_column_name
ON table_name USING btree (column_name);

CREATE INDEX IF NOT EXISTS idx_payment_history_hosteller_id
	ON hostel.payment_history USING btree (hosteller_id);
	
select * from hostel.payment_history where hosteller_id=4;

DROP INDEX IF EXISTS hostel.idx_payment_history_hosteller_id;

SELECT indexname, schemaname, tablename
FROM pg_indexes
WHERE indexname = 'idx_payment_history_hosteller_id';

--- UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
select uuid_generate_v4();
select CONCAT(uuid_generate_v4(),'#',(EXTRACT(EPOCH FROM now() - INTERVAL '1 day') * 1000)::BIGINT);
select CONCAT(uuid_generate_v4(),'#',(EXTRACT(EPOCH FROM now() - INTERVAL '4 hours') * 1000)::BIGINT);

--DENSE_RANK
/** -- Find Nth Highest Salary */

SELECT e.email_id,e.salary,
DENSE_RANK() OVER (ORDER BY e.salary DESC NULLS LAST) AS salary_rank
FROM example_table e;

SELECT t.email_id, t.salary,t.salary_rank
FROM (
    SELECT e.email_id, e.salary,
        DENSE_RANK() OVER (ORDER BY e.salary DESC NULLS LAST) AS salary_rank
    FROM example_table e
) AS t
WHERE t.salary_rank = 2;

/** -- Find Nth Lowest Salary */

select email_id,salary,
DENSE_RANK() OVER (ORDER BY salary) AS salary_rank
FROM example_table;

SELECT t.email_id, t.salary,t.salary_rank
FROM (
    SELECT e.email_id, e.salary,
        DENSE_RANK() OVER (ORDER BY salary) AS salary_rank
    FROM example_table e
) AS t
WHERE t.salary_rank = 2;

SELECT t.email_id, t.salary, t.salary_rank
FROM (
    SELECT e.email_id, e.salary,
        ROW_NUMBER() OVER (ORDER BY salary) AS salary_rank
    FROM example_table e
) AS t
WHERE t.salary_rank = 2;


/**  ------ ROW_NUMER ------ */

SELECT ROW_NUMBER() OVER (ORDER BY now()) AS id;

SELECT ROW_NUMBER() OVER (ORDER BY (select 1)) AS id, e.salary,e.email_id FROM example_table e;

SELECT ROW_NUMBER() OVER (ORDER BY e.salary DESC NULLS LAST) AS id, e.salary,e.email_id 
	FROM example_table e GROUP BY e.salary,e.email_id ;

SELECT ROW_NUMBER() OVER (ORDER BY e.salary) AS id, e.salary,e.email_id 
	FROM example_table e GROUP BY e.salary,e.email_id ;

--STRING_AGG 
select * from example_table;
SELECT
    ROW_NUMBER() OVER (ORDER BY e.salary DESC NULLS LAST) AS id,
    e.salary,
    STRING_AGG(e.email_id, ',') AS email_ids,
	STRING_AGG(e.example_table_id::VARCHAR, ',') AS ex_ids
FROM example_table e
GROUP BY e.salary;

SELECT t.id,t.salary FROM
(
SELECT ROW_NUMBER() OVER (ORDER BY e.salary DESC NULLS LAST) AS id, e.salary 
	FROM example_table e GROUP BY e.salary
) t WHERE t.id=2;

SELECT t.id,t.salary FROM
(
SELECT ROW_NUMBER() OVER (ORDER BY salary) AS id, e.salary
FROM example_table e GROUP BY e.salary
) t WHERE t.id=2;


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

-- SOUNDEX
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

SELECT SOUNDEX('ABC');

--- Queries  ---

--Active and valid
SELECT * FROM example_table
WHERE (end_date IS NULL OR (end_date >= start_date AND end_date >= CURRENT_DATE));
--Active
SELECT * FROM example_table WHERE (end_date IS NULL OR (end_date >= CURRENT_DATE));
-- Inactive
SELECT * FROM example_table WHERE (end_date < CURRENT_DATE);
--Between
SELECT * FROM example_table WHERE joining_date BETWEEN '2024-12-01' AND '2024-12-06';

--- GROUP HAVING
SELECT salary , STRING_AGG(email_id, ',') AS email_ids 
	FROM example_table GROUP BY salary HAVING COUNT(salary) > 1;

SELECT salary, email_id, COUNT(salary)
FROM example_table GROUP BY salary, email_id HAVING COUNT(*) > 1;

-- QUERY ORDER ==> SELECT , FROM , WHERE ,GROUP BY , HAVING , ORDER , LIMIT 
/*
SQL Query Clause Order
SELECT: Specifies the columns or expressions to retrieve.
FROM: Indicates the table(s) or subquery(ies) from which to retrieve data.
WHERE: Filters rows based on specified conditions.
GROUP BY: Groups rows that have the same values in specified columns into aggregated data.
HAVING: Filters grouped data (applied after GROUP BY).
ORDER BY: Specifies the order of the result set (applied after HAVING).
LIMIT or FETCH FIRST: Restricts the number of rows returned.
*/
SELECT column1, column2, COUNT(*) AS count
FROM table_name
WHERE column3 = 'some_condition'
GROUP BY column1, column2
HAVING COUNT(*) > 1
ORDER BY count DESC
LIMIT 10;

---- Union
select full_name from example_table
UNION 
select 'sathish';

---- TRIM
SELECT TRIM('  ss  ');
SELECT TRIM(NULL);

---- LIKE 
select * from example_table where email_id like '%Te%'
select * from example_table where email_id ilike '%Te%' --Contains ignorecase
select * from example_table where email_id ilike 'Te%' --StartWith ignorecase
select * from example_table where salary::text ilike '80%' --startWith

SELECT * FROM example_table 
WHERE email_id ILIKE ANY (ARRAY['%testthree%', '%TestFour%']);

SELECT * FROM example_table WHERE example_table_id =
ANY(CAST(STRING_TO_ARRAY('1,2,3',',') AS INT[]))
AND (email_id = ANY(CAST(STRING_TO_ARRAY('testthree@example.com,testfour@example.com',',') AS VARCHAR[]))
OR 'testthr1,TestFour' ='')


---- SUBSTRING
SELECT SUBSTRING(TRIM(NULLIF('abcderfdg   ','')) FROM 1 FOR 5);

---- UPPER , LOWER
SELECT UPPER('ascdfg ');
SELECT LOWER('ASCDFG ');


---- Version
SHOW server_version;
SELECT VERSION();

--------------------------------

CREATE TABLE tracker_table (
    primary_id SERIAL PRIMARY KEY,
    code_id INT,
    code_value TEXT,
    is_complete CHAR(1),
    uuid UUID DEFAULT gen_random_uuid()
);

INSERT INTO tracker_table (primary_id, code_id, code_value, is_complete, uuid) VALUES
(1, 101, 'abc', 'Y', gen_random_uuid()),
(2, 101, 'xcv', 'N', gen_random_uuid()),
(3, 101, 'jjj', 'N', gen_random_uuid()),
(4, 102, 'llll', 'N', gen_random_uuid());


SELECT * FROM tracker_table;

SELECT DISTINCT ON (code_id) code_id,primary_id
FROM tracker_table ORDER BY code_id,primary_id DESC;

WITH max_data AS (
	SELECT code_id , MAX(primary_id) AS max_primary_id
	FROM tracker_table 
	WHERE code_id IS NOT NULL 
	GROUP BY code_id)
SELECT t.* 
FROM tracker_table t 
JOIN max_data md ON t.primary_id = md.max_primary_id
WHERE t.is_complete = 'N';


SELECT * FROM (
	SELECT DISTINCT ON (code_id) *
	FROM tracker_table 
	WHERE code_id IS NOT NULL 
	ORDER BY code_id,primary_id DESC )
WHERE is_complete = 'N';


------------ SPLIT ---------

SELECT 
TRIM(split_part('ABC = 1', '=', 1)) AS tb_name,
TRIM(split_part('ABC = 1', '=', 2))::INT AS tb_id;

WITH parsed_data AS (
    SELECT 
        TRIM(split_part(value, '=', 1)) AS tb_name,
        TRIM(split_part(value, '=', 2)) AS tb_value
    FROM unnest(string_to_array('ABC = 1 AND ABC = 2 AND ABC = 3', 'AND')) AS value
)
SELECT 
    tb_name,
    STRING_AGG(tb_value, ',') AS tb_values
FROM parsed_data
GROUP BY tb_name;




