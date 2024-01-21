create schema emp;

CREATE TABLE emp.employees
(
    emp_id BIGINT GENERATED ALWAYS AS IDENTITY,
    email_id VARCHAR(150) NOT NULL UNIQUE,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    salary NUMERIC(14,2),
	dob DATE,
    CONSTRAINT employees_pkey PRIMARY KEY (emp_id)
)

-- TRUNCATE TABLE [emp].[employees];

INSERT INTO emp.employees(email_id,first_name,last_name,salary,dob)
     VALUES('skch@gmail8.com','s','k',NULL,now()),
	('skch1@gmail.com','s','k',123.45,now()),
	('skch2@gmail.com','s','k',13,now()),
	('skch3@gmail.com','s','k',3.55,now()),
	('skch4@gmail.com','s','k',0.258,now()),
	('skch5@gmail.com','s','k',67.23,now()),
	('skch6@gmail.com','s','k',NULL,now()),
	('skch7@gmail.com','s','k',NULL,now()),
	('skch@gmail.com','s','k',123.45,now()),
	('skch9@gmail.com','s','k',0.258,now()),
	('skch10@gmail.com','s','k',13,now());
	
	CREATE TABLE emp.emp_type_lkp
(
    emp_type_id BIGINT GENERATED ALWAYS AS IDENTITY,
    emp_type VARCHAR(150) NOT NULL UNIQUE,
    CONSTRAINT emp_type_lkp_pkey PRIMARY KEY (emp_type_id)
)

-- TRUNCATE TABLE [emp].[employees];

INSERT INTO emp.emp_type_lkp(emp_type)
     VALUES('Full'),
	('Partial');

--- COUNT -----

SELECT COUNT(e.emp_id) AS total_count from emp.employees e;

SELECT e.emp_id,e.email_id,COUNT(1) OVER (PARTITION BY 1) AS total_count from emp.employees e;

SELECT e.emp_id,e.email_id,COUNT(1) OVER() AS total_count from emp.employees e;

--- ASC NULLS LAST
select * from emp.employees ORDER BY salary ASC;

-- ASC NULLS FIRST
SELECT * FROM emp.employees ORDER BY salary ASC NULLS FIRST;

-- DESC NULLS FIRST
select * from emp.employees ORDER BY salary DESC;

-- DESC NULLS LAST
SELECT * FROM emp.employees ORDER BY salary DESC NULLS LAST;


/** -- Find Nth Highest Salary */

SELECT e.email_id,e.salary,
DENSE_RANK() OVER (ORDER BY e.salary DESC NULLS LAST) AS salary_rank
FROM emp.employees e;

SELECT t.email_id, t.salary,t.salary_rank
FROM (
    SELECT e.email_id, e.salary,
        DENSE_RANK() OVER (ORDER BY e.salary DESC NULLS LAST) AS salary_rank
    FROM emp.employees e
) AS t
WHERE t.salary_rank = 2;

/** -- Find Nth Lowest Salary */

select email_id,salary,
DENSE_RANK() OVER (ORDER BY salary) AS salary_rank
FROM emp.employees;

SELECT t.email_id, t.salary,t.salary_rank
FROM (
    SELECT e.email_id, e.salary,
        DENSE_RANK() OVER (ORDER BY salary) AS salary_rank
    FROM emp.employees e
) AS t
WHERE t.salary_rank = 2;


/**  ------ ROW_NUMER ------ */

SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS id;

SELECT ROW_NUMBER() OVER (ORDER BY (select 1)) AS id, e.salary,e.email_id FROM emp.employees e;

SELECT ROW_NUMBER() OVER (ORDER BY e.salary DESC NULLS LAST) AS id, e.salary FROM emp.employees e GROUP BY e.salary;

--STRING_AGG(e.email_id, ',') AS email_ids
SELECT
    ROW_NUMBER() OVER (ORDER BY e.salary DESC NULLS LAST) AS id,
    e.salary,
    STRING_AGG(e.email_id, ',') AS email_ids,
	STRING_AGG(e.emp_id::VARCHAR, ',') AS emp_ids
FROM emp.employees e
GROUP BY e.salary;


SELECT t.id,t.salary FROM
(
SELECT ROW_NUMBER() OVER (ORDER BY e.salary DESC NULLS LAST) AS id, e.salary FROM emp.employees e GROUP BY e.salary
) t WHERE t.id=2;


SELECT t.id,t.salary FROM
(
SELECT ROW_NUMBER() OVER (ORDER BY salary) AS id, e.salary
FROM emp.employees e GROUP BY e.salary
) t WHERE t.id=2;


----------------------------
select * from emp.employees;

select * from emp.emp_type_lkp;


select e.emp_id,e.email_id,et.emp_type,e.emp_type_id FROM
emp.employees e left join emp.emp_type_lkp et on et.emp_type_id = e.emp_type_id
WHERE ('' = '' OR e.emp_type_id::text = '')
--(in_param = '' OR e.addr_id::text = in_param);

