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

CREATE TEMP TABLE IF NOT EXISTS temp_table(
	temp_id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	temp_value VARCHAR(100)
) ON COMMIT DROP;

--- DROP --
DROP TABLE IF EXISTS temp_table;

-- TRUNCATE  --
TRUNCATE TABLE temp_table RESTART IDENTITY;

-- INSERT ---
INSERT INTO example_table (
    full_name, email_id, age, dob, salary, joining_date, active, profile_picture,
    bio, preferences, login_attempts, created_at, updated_at, department_id,
    ip_address, mac_address, document, gender
) VALUES ('Test One', 'testone@example.com', 20, '2004-05-15', 20000.00, CURRENT_TIMESTAMP,
    TRUE, NULL,'A software engineer who loves coding.',
    '{"theme": "dark", "notifications": true}', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
    uuid_generate_v4(), '192.168.1.1', '08:00:27:00:4c:02',
    '<document><title>Sample</title></document>', 'M'),
	('Test Two', 'testtwo@example.com', 45, '1993-05-15', 80000.00, CURRENT_TIMESTAMP,
    TRUE, NULL,'A software engineer who loves coding.',
    '{"theme": "dark", "notifications": true}', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
    uuid_generate_v4(), '192.168.1.1', '08:00:27:00:4c:02',
    '<document><title>Sample</title></document>', 'M');

-- ALTER

ALTER TABLE example_table
ADD COLUMN IF NOT EXISTS test varchar(10),
ADD COLUMN IF NOT EXISTS start_date TIMESTAMP,
ADD COLUMN IF NOT EXISTS end_date TIMESTAMP;

ALTER TABLE example_table 
RENAME COLUMN document TO document_value;

ALTER TABLE example_table
DROP COLUMN IF EXISTS test;

-- SELECT 
SELECT * FROM example_table;

-- DATE
SELECT NOW();
SELECT CURRENT_DATE;
SELECT CURRENT_TIMESTAMP;
SHOW TIME ZONE;

SELECT TO_DATE(NULLIF('10/20/2021',''),'MM/dd/yyyy');
SELECT TO_TIMESTAMP(NULLIF('10/20/2021',''),'MM/dd/yyyy');

SELECT CAST(NULLIF('2021-01-25','') AS DATE)
SELECT CAST(NULLIF('2021-01-25','') AS TIMESTAMP)

SELECT CURRENT_DATE + INTERVAL '10 days';
SELECT CURRENT_DATE - INTERVAL '1 month';
SELECT CURRENT_DATE + INTERVAL '5 years';

SELECT AGE('2024-12-31', '2024-01-01');

SELECT AGE(CURRENT_DATE, '2024-10-01');

SELECT CURRENT_DATE - CAST('2024-10-06' AS DATE) AS days_difference;

SELECT (CURRENT_DATE - INTERVAL '4 days')

select * from example_table 
	WHERE (CURRENT_DATE - INTERVAL '4 days')::DATE = joining_date::DATE;

SELECT * FROM example_table
WHERE (end_date IS NULL OR (end_date > start_date AND end_date > CURRENT_DATE));

-- CONCAT
SELECT CONCAT('a',' - ','b');

-- ROW_NUMBER , COUNT
SELECT ROW_NUMBER() OVER (ORDER BY NOW()) AS row_num;
SELECT COUNT(1) OVER() AS total_count;
SELECT COUNT(1) FROM example_table;
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

-- IF 
DO $$
BEGIN
   IF COALESCE('a','') <> '' THEN
      RAISE NOTICE 'TRUE';
   END IF;
END $$;





