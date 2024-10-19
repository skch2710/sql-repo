CREATE TEMP TABLE IF NOT EXISTS temp_data(
        temp_id bigint primary key GENERATED ALWAYS AS IDENTITY,
        full_name VARCHAR(50),
		start_date TIMESTAMP WITHOUT TIME ZONE,
		end_date  TIMESTAMP WITHOUT TIME ZONE
    );

select * from temp_data;

INSERT INTO temp_data (full_name,start_date,end_date)
VALUES ('test1',now(),NULL),('test2','2024-08-22'::TIMESTAMP,NULL);

select * from temp_data where COALESCE(full_name,'')='';

select * from temp_data where ''='' OR COALESCE(full_name,'')='';

--SELECT * FROM temp_data WHERE COALESCE(end_date, NULL) IS NULL;

select * from temp_data WHERE COALESCE(TO_CHAR(end_date,'MM/dd/YYYY'), '') ='09/01/2024';

select * from temp_data WHERE COALESCE(TO_CHAR(start_date,'MM/dd/YYYY'), '') ='09/22/2024';

SELECT * FROM temp_data 
    WHERE start_date BETWEEN '2024-01-01'::timestamp AND NULLIF('', '')::timestamp;

SELECT * FROM temp_data 
    WHERE start_date::date BETWEEN '2024-09-22'::date AND
		COALESCE(NULLIF('2024-09-22', ''), '9999-01-01')::date;

SELECT * FROM temp_data 
    WHERE start_date::date >= '2024-09-22'::timestamp AND
		start_date::date <= COALESCE(NULLIF('', ''),'9999-01-01')::date


select NULLIF('', '');


