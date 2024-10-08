
CREATE OR REPLACE FUNCTION public.fn_insert_user_with_details(
	in_first_name text,
	in_last_name text,
	in_email_id text,
	in_phone_number text,
	in_dob text,
	in_role_name text,
	in_active text,
	in_uploaded_by_id bigint)
    RETURNS TABLE(insrted_new_user_id bigint) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
/***

-- Author	  :	Ch Sathish Kumar
-- Create date: 24-08-2024
-- Description:	insert user details

-- EXEC SCRIPT : select * from public.fn_insert_user_with_details
	(text, text, text, text, text, text, bigint)

***/
DECLARE err_state TEXT; err_message TEXT; err_detail TEXT; err_hint TEXT; err_context TEXT;
DECLARE
    new_user_id BIGINT; in_role_id BIGINT;
BEGIN
	
	-- Insert into users table
    INSERT INTO hostel.users (
        first_name, last_name, email_id, password_salt, phone_number, dob, mail_uuid, user_uuid, is_active, 
        last_login_date, last_password_reset_date, created_by_id, created_date, modified_by_id, modified_date
    )
    VALUES (
        in_first_name, in_last_name, in_email_id, NULL, in_phone_number,TO_DATE(in_dob, 'DDMMYYYY'), NULL,
		CONCAT(uuid_generate_v4(),'#',(EXTRACT(EPOCH FROM NOW()) * 1000)::BIGINT),
		CASE WHEN in_active = 'Yes' THEN true ELSE false END,
		NULL, NULL, in_uploaded_by_id, now(), in_uploaded_by_id, now()
    )
    RETURNING user_id INTO new_user_id;

	--Get the role_id from in_role_name
	SELECT role_id FROM hostel.roles WHERE role_name = in_role_name INTO in_role_id;

    -- Insert into user_roles table
    INSERT INTO hostel.user_roles (
        user_id, role_id, is_active, created_by_id, created_date, modified_by_id, modified_date
    )
    VALUES (
        new_user_id, in_role_id,true, in_uploaded_by_id, now(), in_uploaded_by_id, now()
    );

  -- Insert into user_privileges table
    INSERT INTO hostel.user_privileges (
        user_id, resource_id, read_only_flag, read_write_flag, terminate_flag, is_active, 
        created_by_id, created_date, modified_by_id, modified_date
    )
   SELECT 
        new_user_id, rp.resource_id, rp.read_only_flag, rp.read_write_flag, rp.terminate_flag, 
        true, in_uploaded_by_id, now(), in_uploaded_by_id, now()
    FROM hostel.role_privileges rp
    WHERE rp.role_id = in_role_id;
	
	RAISE NOTICE 'RESULT : %',new_user_id;

	RETURN QUERY SELECT new_user_id;
	
EXCEPTION
    WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS err_state = RETURNED_SQLSTATE,
                            err_message = MESSAGE_TEXT,
                            err_detail = PG_EXCEPTION_DETAIL,
                            err_hint = PG_EXCEPTION_HINT,
                            err_context = PG_EXCEPTION_CONTEXT;
        -- Handle the exception
        RAISE WARNING 'An error occurred: %', SQLERRM;
END;
$BODY$;
