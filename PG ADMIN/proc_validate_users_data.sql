-- PROCEDURE: public.proc_validate_users_data(bigint)

-- DROP PROCEDURE IF EXISTS public.proc_validate_users_data(bigint);

CREATE OR REPLACE PROCEDURE public.proc_validate_users_data(
	IN in_upload_file_id bigint)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    rec RECORD;
    email_pattern CONSTANT TEXT := '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$';
    dob_pattern CONSTANT TEXT := '^\d{4}-\d{2}-\d{2}$';
    phone_number_pattern CONSTANT TEXT := '^\d{10}$';
    final_status TEXT;
    final_error_message TEXT;
	new_user_id BIGINT;
	in_success_count BIGINT;
    in_failure_count BIGINT;
	in_upload_by_id BIGINT;
BEGIN

	SELECT uploaded_by_id INTO in_upload_by_id 
	FROM public.upload_file WHERE upload_file_id = in_upload_file_id;
	
    FOR rec IN SELECT * FROM hostel.users_file_data 
				WHERE upload_file_id = in_upload_file_id LOOP
        -- Initialize status and error message
        final_status := rec.status;
        final_error_message := COALESCE(rec.error_message, '');

        -- Check if the email exists in the users table
        IF EXISTS (SELECT 1 FROM hostel.users u WHERE u.email_id = rec.email_id) THEN
            final_status := 'fail';
            final_error_message := final_error_message || 'Email already exists, ';
        END IF;

        -- Remove trailing comma and space from error_message
        final_error_message := TRIM(BOTH ' ,' FROM final_error_message);

		--Insert into main table
		IF final_status = 'success' THEN
			SELECT fn.insrted_new_user_id INTO new_user_id FROM fn_insert_user_with_details(
			rec.first_name, rec.last_name, rec.email_id, rec.phone_number,
			rec.dob, rec.role_name, in_upload_by_id) fn;
		END IF;

        -- Update the users_stg table
        UPDATE hostel.users_file_data
        SET status = final_status, error_message = NULLIF(final_error_message, ''),
			user_id = new_user_id
        WHERE users_file_data_id = rec.users_file_data_id;
	
		--Need to restet the new_user_id
		 new_user_id := NULL;
    END LOOP;

	SELECT
        COUNT(CASE WHEN status = 'success' THEN 1 END),
        COUNT(CASE WHEN status = 'fail' THEN 1 END)
    INTO in_success_count, in_failure_count
    FROM hostel.users_file_data WHERE upload_file_id = in_upload_file_id;

	-- Update the count in users_file table
	UPDATE upload_file SET success_count = in_success_count,
		failure_count = in_failure_count,
		status_id = 2
		WHERE upload_file_id=in_upload_file_id;

	-- Output the counts
    RAISE NOTICE 'Success count: %, Failure count: %', in_success_count, in_failure_count;

END;
$BODY$;
