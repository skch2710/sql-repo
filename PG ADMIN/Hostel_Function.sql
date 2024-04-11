-- FUNCTION: public.fn_get_hostellers(text, text, text, text, integer, integer, boolean, text)

-- DROP FUNCTION IF EXISTS public.fn_get_hostellers(text, text, text, text, integer, integer, boolean, text);

CREATE OR REPLACE FUNCTION public.fn_get_hostellers(
	in_full_name text DEFAULT ''::text,
	in_email_id text DEFAULT ''::text,
	in_sort_by text DEFAULT 'hosteller_id'::text,
	in_sort_order text DEFAULT 'desc'::text,
	in_page_number integer DEFAULT 1,
	in_page_size integer DEFAULT 5,
	in_is_export boolean DEFAULT false,
	clf_full_name text DEFAULT ''::text)
    RETURNS TABLE(hosteller_id bigint, full_name character varying, email_id character varying, phone_number character varying, fee numeric, joining_date timestamp without time zone, address text, proof text, reason character varying, vacated_date timestamp without time zone, active boolean, total_count bigint) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

/***

-- Author	  :	Ch Sathish Kumar
-- Create date: 11-04-2024
-- Description:	get hostel data

-- EXEC SCRIPT : select * from public.fn_get_hostellers('', '', '', '', 1, 25, false, '')

***/

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
			WHEN in_sort_by = '' THEN 'full_name'
			ELSE in_sort_by
			END || CASE WHEN in_sort_order='asc' THEN ' asc NULLS FIRST' ELSE ' desc NULLS LAST' END;
			
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
$BODY$;

ALTER FUNCTION public.fn_get_hostellers(text, text, text, text, integer, integer, boolean, text)
    OWNER TO postgres;
