--- 1. First Create Schema with table Data On Target DB

-- 2. On Source DB Do the Following

-- Install postgres_fdw extension
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- Create a foreign server for target_db
CREATE SERVER target_db_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'target_db', port '5432');

CREATE USER local_user;

-- Map a local user to a user on target_db
CREATE USER MAPPING FOR local_user
SERVER target_db_server
OPTIONS (user 'postgres', password 'Sathish123');


-- Create a user mapping for the postgres user
CREATE USER MAPPING FOR postgres
SERVER target_db_server
OPTIONS (user 'postgres', password 'Sathish123');

create schema emp;

-- Create a foreign table representing the employees table in target_db
CREATE FOREIGN TABLE emp.employees
(
  emp_id BIGINT ,
    email_id VARCHAR(150) ,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    salary NUMERIC(14,2),
	dob DATE
)
SERVER target_db_server
OPTIONS (table_name 'employees');

select * from emp.employees;
