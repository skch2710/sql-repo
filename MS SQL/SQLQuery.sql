select GETDATE();

SELECT TRIM('  D  ');

SELECT SUBSTRING(TRIM(NULLIF('ASDCDFVS   ','')),1,5);

-- UPPER , LOWER
SELECT UPPER('aaaaa');
SELECT LOWER('AAAAA');

-- CONCAT
SELECT CONCAT('abc',' - ','cdf');

SELECT 1;

--- DATE FORMAT

SELECT FORMAT(GETDATE(), 'MM/dd/yyyy');

SELECT CAST(FORMAT(GETDATE(), 'MM/dd/yyyy') AS VARCHAR(10));

SELECT CONVERT(VARCHAR, GETDATE(), 101);

SELECT CAST(GETDATE() AS DATE);

--- JSON

SELECT * FROM [hostel].[users]

SELECT 
    user_id AS user_id,
    email_id AS email_id
FROM [hostel].[users]
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

SELECT 
    MAX(dob) AS max_dob,
    MIN(dob) AS min_dob
FROM [hostel].[users] 
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

