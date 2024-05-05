
---Date Convertions

SELECT CAST(CURRENT_TIMESTAMP AS DATE) AS DateOnly

SELECT CONVERT(DATE, CURRENT_TIMESTAMP) AS DateOnly

SELECT CONVERT(VARCHAR, CURRENT_TIMESTAMP, 101) AS FormattedDate --100,101,..105....
SELECT CONVERT(VARCHAR, CONVERT(DATE, '2022-01-21', 23), 105) AS FormattedDate --100,101,..105....

SELECT CONVERT(DATE, '21/01/2022', 103) AS ConvertedDate
SELECT CONVERT(DATE, '01/21/2022', 101) AS ConvertedDate


--- Number Convertions

SELECT CONVERT(NUMERIC(14,2), 111) AS num

SELECT FORMAT(1443111.49, 'C', 'en-US') AS FormattedNumber

SELECT FORMAT(1443111.49, 'C', 'en-IN') AS FormattedNumber

SELECT '$ ' + FORMAT(1443111.49, '###,###,##0.00', 'en-US') AS FormattedNumber

SELECT FORMAT(1443111.49, '##,##,##0.00', 'en-IN') AS FormattedNumber

SELECT FORMAT(1443111, '###,###,##0', 'en-US') AS FormattedNumber

SELECT FORMAT(1443111, '##,##,##0', 'en-IN') AS FormattedNumber

SELECT 
  CASE 
    WHEN -1443111.49 >= 0 THEN '$ ' + FORMAT(-1443111.49, '###,###,##0.00', 'en-US')
    ELSE '$ (' + FORMAT(ABS(-1443111.49), '###,###,##0.00', 'en-US') + ')'
  END AS formatted_value;

