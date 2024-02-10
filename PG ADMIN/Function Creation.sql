select * from login.employees;

select * from fn_employee_data();

-- DROP FUNCTION fn_employee_data();

CREATE OR REPLACE FUNCTION public.fn_employee_data()
RETURNS TABLE (rn_id BIGINT,emp_id BIGINT, email_id VARCHAR,first_name VARCHAR,last_name VARCHAR,created_by_id BIGINT,
			   emp_role_id BIGINT,role_id BIGINT,role_name VARCHAR,is_external_role boolean,total_count BIGINT)
AS $$
BEGIN
    RETURN QUERY
    	select ROW_NUMBER() OVER (ORDER BY (select 1)) AS rn_id,
		e.emp_id,e.email_id,e.first_name,e.last_name,e.created_by_id,
		er.emp_role_id,r.role_id,r.role_name,r.is_external_role,
		COUNT(1) OVER (PARTITION BY 1) AS total_count
		FROM login.employees e LEFT JOIN login.emp_roles er ON e.emp_id=er.emp_id 
	    LEFT JOIN login.roles r ON r.role_id = er.role_id;
END;
$$ LANGUAGE plpgsql;


/****** Function With Dynamic SQL And Exception *****/

select * from fn_employee_data();

-- DROP FUNCTION fn_employee_data();

CREATE OR REPLACE FUNCTION public.fn_employee_data()
RETURNS TABLE (rn_id BIGINT, emp_id BIGINT, email_id VARCHAR, first_name VARCHAR, last_name VARCHAR, created_by_id BIGINT,
               emp_role_id BIGINT, role_id BIGINT, role_name VARCHAR, is_external_role BOOLEAN, total_count BIGINT)
AS $BODY$

DECLARE dynamic_sql TEXT;
DECLARE err_state TEXT; err_message TEXT; err_detail TEXT; err_hint TEXT; err_context TEXT;

BEGIN
    dynamic_sql := 'SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn_id,
                    e.emp_id, e.email_id, e.first_name, e.last_name, e.created_by_id,
                    er.emp_role_id, r.role_id, r.role_name, r.is_external_role,
                    COUNT(1) OVER (PARTITION BY 1) AS total_count
                    FROM login.employees e
                    LEFT JOIN login.emp_roles er ON e.emp_id = er.emp_id 
                    LEFT JOIN login.roles r ON r.role_id = er.role_id';
    
    -- Print the generated SQL statement for debugging
    RAISE NOTICE 'Generated SQL Statement: %', dynamic_sql;

    -- Execute the dynamic SQL statement and return the results
    RETURN QUERY EXECUTE dynamic_sql;

EXCEPTION
    -- Catch any SQL errors and raise a NOTICE with the error message
    WHEN OTHERS THEN
		/** Simple Way **/
        --RAISE NOTICE 'An error occurred while executing dynamic SQL: %', SQLERRM;
		--INSERT INTO public.fn_errors(fn_name, dynamic_sql, fn_error)
		--VALUES ('public.fn_employee_data', dynamic_sql, SQLERRM);
		/** Retrieve stacked diagnostics **/
        GET STACKED DIAGNOSTICS err_state = RETURNED_SQLSTATE,
                            err_message = MESSAGE_TEXT,
                            err_detail = PG_EXCEPTION_DETAIL,
                            err_hint = PG_EXCEPTION_HINT,
                            err_context = PG_EXCEPTION_CONTEXT;

        -- Raise a notice with the error message and stacked diagnostics
        RAISE NOTICE 'An error occurred while executing dynamic SQL>>>>  SQLSTATE: %.  Message: %. Detail: %. Hint: %. Context: %',
                        err_state, err_message, err_detail, err_hint, err_context;
		INSERT INTO public.error_logs(object_name, object_type, err_state,err_message,err_detail,err_hint,err_context)
		VALUES ('public.fn_employee_data','FUNCTION', err_state,err_message,err_detail,err_hint,err_context);
        RETURN;
END;
$BODY$ LANGUAGE plpgsql;

/**** Table to Store the function Exceptions **/
select * from public.error_logs;
CREATE TABLE IF NOT EXISTS public.error_logs
(
    err_log_id bigint GENERATED ALWAYS AS IDENTITY,
    object_name TEXT,
	object_type TEXT,
	err_state TEXT,
    err_message TEXT,
	err_detail TEXT,
	err_hint TEXT,
	err_context TEXT,
    created_date TIMESTAMP DEFAULT now(),
    
    CONSTRAINT error_logs_pkey PRIMARY KEY (err_log_id)
);

/******** Function With Pagination Sort ****/

-- select * from public.get_employee_data('1,2','','skch2710@gmail.com,skch@gmail.com','','','','',1,25,false,'','08/30/2023');

CREATE OR REPLACE FUNCTION public.get_employee_data(
	in_emp_id text DEFAULT ''::text,
	in_emp_role_id text DEFAULT ''::text,
	in_email_id text DEFAULT ''::text,
	in_first_name text DEFAULT ''::text,
	in_created_date text DEFAULT ''::text,
	in_sort_by text DEFAULT 'id',
	in_sort_order text DEFAULT 'ASC',
	in_Page_number integer DEFAULT 1,
	in_page_size integer DEFAULT 25,
	in_is_export boolean DEFAULT false,
	clf_last_name text DEFAULT ''::text,
	clf_modified_date text DEFAULT ''::text
)
RETURNS TABLE (rn_id BIGINT,emp_id BIGINT, email_id VARCHAR,first_name VARCHAR,last_name VARCHAR,created_by_id BIGINT,
			   emp_role_id BIGINT,role_id BIGINT,role_name VARCHAR,is_external_role boolean,modified_date TIMESTAMP,total_count BIGINT)
AS $BODY$

DECLARE dynamic_sql text;

BEGIN

	DROP TABLE IF EXISTS temp_emp_data;
	
	CREATE TEMPORARY TABLE temp_emp_data AS
    	SELECT e.emp_id,e.email_id,e.first_name,e.last_name,e.created_by_id,
		er.emp_role_id,r.role_id,r.role_name,r.is_external_role,
		e.modified_date
		FROM login.employees e LEFT JOIN login.emp_roles er ON e.emp_id=er.emp_id 
	    LEFT JOIN login.roles r ON r.role_id = er.role_id
		WHERE (e.emp_id = ANY(CAST(STRING_TO_ARRAY(in_emp_id,',')AS INT[])) OR in_emp_id = '')
		AND (e.email_id = ANY(CAST(STRING_TO_ARRAY(in_email_id,',')AS VARCHAR[])) OR in_email_id ='')
		AND (e.first_name ILIKE in_first_name||'%' OR in_first_name ='')
		AND (e.created_date::date = in_created_date::date OR in_created_date ='')
		AND (er.emp_role_id = CASE WHEN in_emp_role_id = '' THEN  er.emp_role_id ELSE in_emp_role_id::bigint END);
		
	dynamic_sql := 'select ROW_NUMBER() OVER (PARTITION BY now()) AS rn_id,emp_id,email_id,first_name,last_name,created_by_id,
				emp_role_id,role_id,role_name,is_external_role,modified_date,COUNT(1) OVER() AS total_count
				FROM temp_emp_data WHERE 1=1';
		
	IF COALESCE(clf_last_name , '') <> '' THEN
		dynamic_sql := dynamic_sql || ' AND last_name ilike $1 ';
		END IF;
	
	IF COALESCE(clf_modified_date , '') <> '' THEN
		dynamic_sql := dynamic_sql || ' AND modified_date::date = $4::date ';
		END IF;
		
	dynamic_sql := dynamic_sql || ' ORDER BY ' ||
		CASE 
			WHEN in_sort_by = 'last_name' THEN 'last_name'
			WHEN in_sort_by = 'modified_date' THEN 'modified_date'
			ELSE 'emp_id'
			END || CASE WHEN in_sort_order='desc' THEN ' DESC NULLS LAST' ELSE ' ASC NULLS FIRST' END;
			
	IF COALESCE(in_is_export,'false') ='false' THEN
		dynamic_sql := dynamic_sql ||' LIMIT $2 OFFSET ($3 - 1) * $2';
	END IF;
	
	RAISE NOTICE 'Generated SQL Statement: %', dynamic_sql;
	
	RETURN QUERY EXECUTE dynamic_sql using clf_last_name||'%',in_page_size,in_page_number,
	clf_modified_date;
	
END;
$BODY$ LANGUAGE plpgsql;
