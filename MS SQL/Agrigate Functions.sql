create schema emp;

CREATE TABLE emp.employees
(
    emp_id BIGINT IDENTITY(1,1),
    email_id VARCHAR(150) NOT NULL UNIQUE,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    salary NUMERIC(14,2),
	dob DATETIME,
    CONSTRAINT employees_pkey PRIMARY KEY (emp_id)
)

-- TRUNCATE TABLE [emp].[employees];

INSERT INTO [emp].[employees]([email_id],[first_name],[last_name],[salary],[dob])
     VALUES('skch@gmail8.com','s','k',NULL,GETDATE()),
	('skch1@gmail.com','s','k',123.45,GETDATE()),
	('skch2@gmail.com','s','k',13,GETDATE()),
	('skch3@gmail.com','s','k',3.55,GETDATE()),
	('skch4@gmail.com','s','k',0.258,GETDATE()),
	('skch5@gmail.com','s','k',67.23,GETDATE()),
	('skch6@gmail.com','s','k',NULL,GETDATE()),
	('skch7@gmail.com','s','k',NULL,GETDATE()),
	('skch@gmail.com','s','k',123.45,GETDATE()),
	('skch9@gmail.com','s','k',0.258,GETDATE()),
	('skch10@gmail.com','s','k',13,GETDATE());


--- COUNT -----

SELECT COUNT(e.emp_id) AS total_count from emp.employees e;

SELECT e.emp_id,e.email_id,COUNT(1) OVER (PARTITION BY 1) AS total_count from emp.employees e;

--- ASC NULLS FIRST
select * from emp.employees ORDER BY salary ASC;

-- ASC NULLS LAST
SELECT * FROM emp.employees
ORDER BY CASE WHEN salary IS NULL THEN 1 ELSE 0 END, salary ASC;

-- DESC NULLS LAST
select * from emp.employees ORDER BY salary DESC;

-- DESC NULLS FIRST
SELECT * FROM emp.employees
ORDER BY CASE WHEN salary IS NULL THEN 0 ELSE 1 END, salary DESC;


/** -- Find Nth Highest Salary */

SELECT e.email_id,e.salary,
DENSE_RANK() OVER (ORDER BY e.salary DESC) AS SalaryRank
FROM emp.employees e;

SELECT t.email_id, t.salary
FROM (
    SELECT e.email_id, e.salary,
        DENSE_RANK() OVER (ORDER BY e.salary DESC) AS SalaryRank
    FROM emp.employees e
) AS t
WHERE t.SalaryRank = 3;

/** -- Find Nth Lowest Salary */

select email_id,salary,
DENSE_RANK() OVER (ORDER BY CASE WHEN salary IS NULL THEN 1 ELSE 0 END, salary) AS SalaryRank
FROM emp.employees;

SELECT t.email_id, t.salary
FROM (
    SELECT e.email_id, e.salary,
        DENSE_RANK() OVER (ORDER BY CASE WHEN salary IS NULL THEN 1 ELSE 0 END, salary) AS SalaryRank
    FROM emp.employees e
) AS t
WHERE t.SalaryRank = 3;


/**  ------ ROW_NUMER ------ */

SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS id;

SELECT ROW_NUMBER() OVER (ORDER BY (select 1)) AS id, e.salary,e.email_id FROM emp.employees e;

SELECT ROW_NUMBER() OVER (ORDER BY e.salary DESC) AS id, e.salary FROM emp.employees e GROUP BY e.salary;

--STRING_AGG(e.email_id, ',') AS email_ids
SELECT ROW_NUMBER() OVER (ORDER BY e.salary DESC) AS id, e.salary,
STRING_AGG(e.email_id, ',') AS email_ids,
STRING_AGG(e.emp_id, ',') AS emp_ids
FROM emp.employees e GROUP BY e.salary;


SELECT t.id,t.salary FROM
(
SELECT ROW_NUMBER() OVER (ORDER BY e.salary DESC) AS id, e.salary FROM emp.employees e GROUP BY e.salary
) t WHERE t.id=2;


SELECT t.id,t.salary FROM
(
SELECT ROW_NUMBER() OVER (ORDER BY CASE WHEN salary IS NULL THEN 1 ELSE 0 END, salary) AS id, e.salary
FROM emp.employees e GROUP BY e.salary
) t WHERE t.id=2;