
--select * from public.fn_get_hostellers('', '', '', '', 1, 25, false, '');

CREATE OR REPLACE FUNCTION public.fn_get_hostellers(
	in_full_name TEXT DEFAULT ''::TEXT,
	in_email_id TEXT DEFAULT ''::TEXT,
	in_sort_by TEXT DEFAULT 'hosteller_id',
	in_sort_order TEXT DEFAULT 'DESC',
	in_Page_number INTEGER DEFAULT 1,
	in_page_size INTEGER DEFAULT 5,
	in_is_export BOOLEAN DEFAULT false,
	clf_full_name TEXT DEFAULT ''
)
RETURNS TABLE (hosteller_id BIGINT,full_name VARCHAR, email_id VARCHAR,phone_number VARCHAR,fee NUMERIC(14,2),joining_date TIMESTAMP,
			   address TEXT,proof TEXT,reason VARCHAR,vacated_date TIMESTAMP,active BOOLEAN,total_count BIGINT)
AS $BODY$

DECLARE dynamic_sql TEXT;
DECLARE err_state TEXT; err_message TEXT; err_detail TEXT; err_hint TEXT; err_conTEXT TEXT;
BEGIN

	DROP TABLE IF EXISTS temp_hostel_data;
	
	CREATE TEMPORARY TABLE temp_hostel_data AS
    	SELECT h.hosteller_id,h.full_name, h.email_id,
		h.phone_number,h.fee,h.joining_date ,
		h.address ,h.proof ,h.reason ,
		h.vacated_date ,h.active
		FROM hostel.hostellers h
		WHERE (h.full_name ILIKE in_full_name||'%' OR in_full_name ='')
		AND (h.email_id ILIKE in_email_id||'%' OR in_email_id ='');
		
	dynamic_sql := 'select *,COUNT(1) OVER() AS total_count
				FROM temp_hostel_data WHERE 1=1';
	
	IF COALESCE(clf_full_name , '') <> '' THEN
		dynamic_sql := dynamic_sql || ' AND full_name ilike $1 ';
		END IF;
	
	dynamic_sql := dynamic_sql || ' ORDER BY ' ||
		CASE 
			WHEN in_sort_by = 'full_name' THEN 'full_name'
			WHEN in_sort_by = 'email_id' THEN 'email_id'
			WHEN in_sort_by = 'hosteller_id' THEN 'hosteller_id'
			ELSE 'hosteller_id'
			END || CASE WHEN in_sort_order='ASC' THEN ' ASC NULLS FIRST' ELSE ' DESC NULLS LAST' END;
			
	IF COALESCE(in_is_export,'false') ='false' THEN
		dynamic_sql := dynamic_sql ||' LIMIT $2 OFFSET ($3 - 1) * $2';
	END IF;
	
	RAISE NOTICE 'Generated SQL Statement: %', dynamic_sql;
	
	RETURN QUERY EXECUTE dynamic_sql USING clf_full_name||'%',in_page_size,in_page_number;

EXCEPTION
    -- Catch any SQL errors and raise a NOTICE with the error message
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS err_state = RETURNED_SQLSTATE,
                            err_message = MESSAGE_TEXT,
                            err_detail = PG_EXCEPTION_DETAIL,
                            err_hint = PG_EXCEPTION_HINT,
                            err_context = PG_EXCEPTION_CONTEXT;
        -- Raise a notice with the error message and stacked diagnostics
        RAISE WARNING 'An error occurred while executing dynamic SQL>>>>  SQLSTATE: %.  Message: %. Detail: %. Hint: %. ConTEXT: %',
                        err_state, err_message, err_detail, err_hint, err_context;
		--INSERT INTO public.error_logs(object_name, object_type, err_state,err_message,err_detail,err_hint,err_context)
		--VALUES ('public.get_employee_data','FUNCTION', err_state,err_message,err_detail,err_hint,err_context);
        RETURN;

END;
$BODY$ LANGUAGE plpgsql;