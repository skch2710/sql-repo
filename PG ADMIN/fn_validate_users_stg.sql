-- FUNCTION: public.fn_validate_users_stg(bigint)

--DROP FUNCTION IF EXISTS public.fn_validate_users_stg(bigint);

CREATE OR REPLACE FUNCTION public.fn_validate_users_stg(
	in_upload_file_id bigint)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    rec RECORD;
    email_pattern CONSTANT TEXT := '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$';
    dob_pattern CONSTANT TEXT := '^\d{4}-\d{2}-\d{2}$';
    phone_number_pattern CONSTANT TEXT := '^\d{10}$';
    final_status TEXT;
    final_error_message TEXT;
	new_user_id BIGINT;
	success_count BIGINT;
	failure_count BIGINT;
BEGIN
    FOR rec IN SELECT * FROM users_stg WHERE upload_file_id = in_upload_file_id 
						AND status IS NULL	LOOP
        -- Initialize status and error message
        final_status := 'success';
        final_error_message := '';

        -- Check if the email is valid
        IF rec.email_id !~* email_pattern THEN
            final_status := 'fail';
            final_error_message := final_error_message || 'Invalid email format, ';
        END IF;

        -- Check if the email exists in the users table
        IF EXISTS (SELECT 1 FROM hostel.users u WHERE u.email_id = rec.email_id) THEN
            final_status := 'fail';
            final_error_message := final_error_message || 'Email already exists, ';
        END IF;

        -- Check if the dob is in yyyy-MM-dd format
        IF rec.dob !~* dob_pattern THEN
            final_status := 'fail';
            final_error_message := final_error_message || 'Invalid dob format, ';
        END IF;

        -- Check if the phone number is valid
        IF rec.phone_number !~* phone_number_pattern THEN
            final_status := 'fail';
            final_error_message := final_error_message || 'Invalid phone number format, ';
        END IF;

        -- Remove trailing comma and space from error_message
        final_error_message := TRIM(BOTH ' ,' FROM final_error_message);

		--Insert into main table
		IF final_status = 'success' THEN
			SELECT fn.insrted_new_user_id INTO new_user_id FROM fn_insert_user_with_details(
			rec.first_name,rec.last_name,rec.email_id,rec.phone_number,
			rec.dob,rec.role_name) fn;
		END IF;

        -- Update the users_stg table
        UPDATE users_stg
        SET status = final_status, error_message = NULLIF(final_error_message, ''),
			user_id = new_user_id
        WHERE users_stg_id = rec.users_stg_id;
    END LOOP;

 -- Output the new_user_id value
    --RAISE NOTICE 'The new_user_id is: %', new_user_id;
	
	SELECT
        COUNT(CASE WHEN status = 'success' THEN 1 END),
        COUNT(CASE WHEN status = 'fail' THEN 1 END)
    INTO success_count, failure_count
    FROM users_stg WHERE upload_file_id = in_upload_file_id;

-- Update the count in upload_file table
	UPDATE upload_file SET success_count = in_success_count,
		failure_count = in_failure_count,
		status_id = 2
		WHERE upload_file_id=in_upload_file_id;

	-- Output the counts
    RAISE NOTICE 'Success count: %, Failure count: %', success_count, failure_count;

END;
$BODY$;

ALTER FUNCTION public.fn_validate_users_stg(bigint)
    OWNER TO postgres;
