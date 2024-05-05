---Date Convertions

select now() :: timestamp without time zone

select now() :: date

select '2022-01-21' :: date

SELECT TO_CHAR(now(), 'MM/DD/YYYY') AS formatted_date;

SELECT TO_CHAR(now(), 'DD-MM-YYYY') AS formatted_date;


--- Number Convertions

select -20 :: numeric(14,2);

SELECT '$' || TO_CHAR(14333333.49, '999,999,999.99') AS formatted_value;

SELECT TO_CHAR(14333333.49, '99,99,99,999') AS formatted_value;


SELECT 
  CASE 
    WHEN -20 >= 0 THEN '$' || TO_CHAR(-20, '999,999,999.99')
    ELSE '$ (' || TO_CHAR(ABS(-20), '999,999,999.99') || ')'
  END AS formatted_value;

