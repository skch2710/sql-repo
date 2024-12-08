SHOW data_directory;

SELECT * FROM pg_catalog.pg_ls_dir('C:/Program Files/PostgreSQL/17/data/nppes');

SELECT * FROM pg_catalog.pg_read_file('C:/Program Files/PostgreSQL/17/data/nppes/npidata_pfile_20240902-20240908.csv');

DROP TABLE IF EXISTS temp_users;
CREATE TEMP TABLE temp_users (
	temp_users_id bigint PRIMARY KEY, -- GENERATED ALWAYS AS IDENTITY,
    first_name TEXT,
    last_name TEXT,
    email_id TEXT,
    phone_number TEXT,
    dob TEXT,
    role_name TEXT,
    active TEXT
);

COPY temp_users (first_name, last_name, email_id, phone_number, dob, role_name, active)
FROM 'C:/Program Files/PostgreSQL/16/data/tempfiles/largeOne_1728118838673.csv'
DELIMITER '|'
CSV HEADER;

COPY temp_users (temp_users_id,first_name, last_name, email_id, phone_number, dob, role_name, active)
FROM 'C:/Program Files/PostgreSQL/16/data/tempfiles/data-1728196655629.csv'
DELIMITER ','  -- Assuming the CSV is comma-delimited
CSV HEADER;

COPY hostel.file_status (status_id,status, created_by_id, created_date, modified_by_id, modified_date)
FROM 'C:/Program Files/PostgreSQL/16/data/tempfiles/file_status.csv'
DELIMITER ','
CSV HEADER;

select * from hostel.file_status;

truncate table hostel.file_status restart identity;

select * from temp_users;

truncate table temp_users restart identity;


----------- NPPES -------

-- SELECT * FROM public.nppes_npi_data_file_stg WHERE npi = '1912731803'

CREATE TABLE IF NOT EXISTS public.nppes_npi_data_file_stg
(
    npi character varying ,
    entity_type_code character varying ,
    replacement_npi character varying ,
    employer_identification_number character varying ,
    provider_organization_name character varying ,
    provider_last_name character varying ,
    provider_first_name character varying ,
    provider_middle_name character varying ,
    provider_name_prefix_text character varying ,
    provider_name_suffix_text character varying ,
    provider_credential_text character varying ,
    provider_other_organization_name character varying ,
    provider_other_organization_name_type_code character varying ,
    provider_other_last_name character varying ,
    provider_other_first_name character varying ,
    provider_other_middle_name character varying ,
    provider_other_name_prefix_text character varying ,
    provider_other_name_suffix_text character varying ,
    provider_other_credential_text character varying ,
    provider_other_last_name_type_code character varying ,
    provider_first_line_business_mailing_address character varying ,
    provider_second_line_business_mailing_address character varying ,
    provider_business_mailing_address_city_name character varying ,
    provider_business_mailing_address_state_name character varying ,
    provider_business_mailing_address_postal_code character varying ,
    provider_business_mailing_address_country_code character varying ,
    provider_business_mailing_address_telephone_number character varying ,
    provider_business_mailing_address_fax_number character varying ,
    provider_first_line_business_practice_location_address character varying ,
    provider_second_line_business_practice_location_address character varying ,
    provider_business_practice_location_address_city_name character varying ,
    provider_business_practice_location_address_state_name character varying ,
    provider_business_practice_location_address_postal_code character varying ,
    provider_business_practice_location_address_country_code character varying ,
    provider_business_practice_location_address_telephone_number character varying ,
    provider_business_practice_location_address_fax_number character varying ,
    provider_enumeration_date character varying ,
    last_update_date character varying ,
    npi_deactivation_reason_code character varying ,
    npi_deactivation_date character varying ,
    npi_reactivation_date character varying ,
    provider_gender_code character varying ,
    authorized_official_last_name character varying ,
    authorized_official_first_name character varying ,
    authorized_official_middle_name character varying ,
    authorized_official_title_or_position character varying ,
    authorized_official_telephone_number character varying ,
    healthcare_provider_taxonomy_code_1 character varying ,
    provider_license_number_1 character varying ,
    provider_license_number_state_code_1 character varying ,
    healthcare_provider_primary_taxonomy_switch_1 character varying ,
    healthcare_provider_taxonomy_code_2 character varying ,
    provider_license_number_2 character varying ,
    provider_license_number_state_code_2 character varying ,
    healthcare_provider_primary_taxonomy_switch_2 character varying ,
    healthcare_provider_taxonomy_code_3 character varying ,
    provider_license_number_3 character varying ,
    provider_license_number_state_code_3 character varying ,
    healthcare_provider_primary_taxonomy_switch_3 character varying ,
    healthcare_provider_taxonomy_code_4 character varying ,
    provider_license_number_4 character varying ,
    provider_license_number_state_code_4 character varying ,
    healthcare_provider_primary_taxonomy_switch_4 character varying ,
    healthcare_provider_taxonomy_code_5 character varying ,
    provider_license_number_5 character varying ,
    provider_license_number_state_code_5 character varying ,
    healthcare_provider_primary_taxonomy_switch_5 character varying ,
    healthcare_provider_taxonomy_code_6 character varying ,
    provider_license_number_6 character varying ,
    provider_license_number_state_code_6 character varying ,
    healthcare_provider_primary_taxonomy_switch_6 character varying ,
    healthcare_provider_taxonomy_code_7 character varying ,
    provider_license_number_7 character varying ,
    provider_license_number_state_code_7 character varying ,
    healthcare_provider_primary_taxonomy_switch_7 character varying ,
    healthcare_provider_taxonomy_code_8 character varying ,
    provider_license_number_8 character varying ,
    provider_license_number_state_code_8 character varying ,
    healthcare_provider_primary_taxonomy_switch_8 character varying ,
    healthcare_provider_taxonomy_code_9 character varying ,
    provider_license_number_9 character varying ,
    provider_license_number_state_code_9 character varying ,
    healthcare_provider_primary_taxonomy_switch_9 character varying ,
    healthcare_provider_taxonomy_code_10 character varying ,
    provider_license_number_10 character varying ,
    provider_license_number_state_code_10 character varying ,
    healthcare_provider_primary_taxonomy_switch_10 character varying ,
    healthcare_provider_taxonomy_code_11 character varying ,
    provider_license_number_11 character varying ,
    provider_license_number_state_code_11 character varying ,
    healthcare_provider_primary_taxonomy_switch_11 character varying ,
    healthcare_provider_taxonomy_code_12 character varying ,
    provider_license_number_12 character varying ,
    provider_license_number_state_code_12 character varying ,
    healthcare_provider_primary_taxonomy_switch_12 character varying ,
    healthcare_provider_taxonomy_code_13 character varying ,
    provider_license_number_13 character varying ,
    provider_license_number_state_code_13 character varying ,
    healthcare_provider_primary_taxonomy_switch_13 character varying ,
    healthcare_provider_taxonomy_code_14 character varying ,
    provider_license_number_14 character varying ,
    provider_license_number_state_code_14 character varying ,
    healthcare_provider_primary_taxonomy_switch_14 character varying ,
    healthcare_provider_taxonomy_code_15 character varying ,
    provider_license_number_15 character varying ,
    provider_license_number_state_code_15 character varying ,
    healthcare_provider_primary_taxonomy_switch_15 character varying ,
    other_provider_identifier_1 character varying ,
    other_provider_identifier_type_code_1 character varying ,
    other_provider_identifier_state_1 character varying ,
    other_provider_identifier_issuer_1 character varying ,
    other_provider_identifier_2 character varying ,
    other_provider_identifier_type_code_2 character varying ,
    other_provider_identifier_state_2 character varying ,
    other_provider_identifier_issuer_2 character varying ,
    other_provider_identifier_3 character varying ,
    other_provider_identifier_type_code_3 character varying ,
    other_provider_identifier_state_3 character varying ,
    other_provider_identifier_issuer_3 character varying ,
    other_provider_identifier_4 character varying ,
    other_provider_identifier_type_code_4 character varying ,
    other_provider_identifier_state_4 character varying ,
    other_provider_identifier_issuer_4 character varying ,
    other_provider_identifier_5 character varying ,
    other_provider_identifier_type_code_5 character varying ,
    other_provider_identifier_state_5 character varying ,
    other_provider_identifier_issuer_5 character varying ,
    other_provider_identifier_6 character varying ,
    other_provider_identifier_type_code_6 character varying ,
    other_provider_identifier_state_6 character varying ,
    other_provider_identifier_issuer_6 character varying ,
    other_provider_identifier_7 character varying ,
    other_provider_identifier_type_code_7 character varying ,
    other_provider_identifier_state_7 character varying ,
    other_provider_identifier_issuer_7 character varying ,
    other_provider_identifier_8 character varying ,
    other_provider_identifier_type_code_8 character varying ,
    other_provider_identifier_state_8 character varying ,
    other_provider_identifier_issuer_8 character varying ,
    other_provider_identifier_9 character varying ,
    other_provider_identifier_type_code_9 character varying ,
    other_provider_identifier_state_9 character varying ,
    other_provider_identifier_issuer_9 character varying ,
    other_provider_identifier_10 character varying ,
    other_provider_identifier_type_code_10 character varying ,
    other_provider_identifier_state_10 character varying ,
    other_provider_identifier_issuer_10 character varying ,
    other_provider_identifier_11 character varying ,
    other_provider_identifier_type_code_11 character varying ,
    other_provider_identifier_state_11 character varying ,
    other_provider_identifier_issuer_11 character varying ,
    other_provider_identifier_12 character varying ,
    other_provider_identifier_type_code_12 character varying ,
    other_provider_identifier_state_12 character varying ,
    other_provider_identifier_issuer_12 character varying ,
    other_provider_identifier_13 character varying ,
    other_provider_identifier_type_code_13 character varying ,
    other_provider_identifier_state_13 character varying ,
    other_provider_identifier_issuer_13 character varying ,
    other_provider_identifier_14 character varying ,
    other_provider_identifier_type_code_14 character varying ,
    other_provider_identifier_state_14 character varying ,
    other_provider_identifier_issuer_14 character varying ,
    other_provider_identifier_15 character varying ,
    other_provider_identifier_type_code_15 character varying ,
    other_provider_identifier_state_15 character varying ,
    other_provider_identifier_issuer_15 character varying ,
    other_provider_identifier_16 character varying ,
    other_provider_identifier_type_code_16 character varying ,
    other_provider_identifier_state_16 character varying ,
    other_provider_identifier_issuer_16 character varying ,
    other_provider_identifier_17 character varying ,
    other_provider_identifier_type_code_17 character varying ,
    other_provider_identifier_state_17 character varying ,
    other_provider_identifier_issuer_17 character varying ,
    other_provider_identifier_18 character varying ,
    other_provider_identifier_type_code_18 character varying ,
    other_provider_identifier_state_18 character varying ,
    other_provider_identifier_issuer_18 character varying ,
    other_provider_identifier_19 character varying ,
    other_provider_identifier_type_code_19 character varying ,
    other_provider_identifier_state_19 character varying ,
    other_provider_identifier_issuer_19 character varying ,
    other_provider_identifier_20 character varying ,
    other_provider_identifier_type_code_20 character varying ,
    other_provider_identifier_state_20 character varying ,
    other_provider_identifier_issuer_20 character varying ,
    other_provider_identifier_21 character varying ,
    other_provider_identifier_type_code_21 character varying ,
    other_provider_identifier_state_21 character varying ,
    other_provider_identifier_issuer_21 character varying ,
    other_provider_identifier_22 character varying ,
    other_provider_identifier_type_code_22 character varying ,
    other_provider_identifier_state_22 character varying ,
    other_provider_identifier_issuer_22 character varying ,
    other_provider_identifier_23 character varying ,
    other_provider_identifier_type_code_23 character varying ,
    other_provider_identifier_state_23 character varying ,
    other_provider_identifier_issuer_23 character varying ,
    other_provider_identifier_24 character varying ,
    other_provider_identifier_type_code_24 character varying ,
    other_provider_identifier_state_24 character varying ,
    other_provider_identifier_issuer_24 character varying ,
    other_provider_identifier_25 character varying ,
    other_provider_identifier_type_code_25 character varying ,
    other_provider_identifier_state_25 character varying ,
    other_provider_identifier_issuer_25 character varying ,
    other_provider_identifier_26 character varying ,
    other_provider_identifier_type_code_26 character varying ,
    other_provider_identifier_state_26 character varying ,
    other_provider_identifier_issuer_26 character varying ,
    other_provider_identifier_27 character varying ,
    other_provider_identifier_type_code_27 character varying ,
    other_provider_identifier_state_27 character varying ,
    other_provider_identifier_issuer_27 character varying ,
    other_provider_identifier_28 character varying ,
    other_provider_identifier_type_code_28 character varying ,
    other_provider_identifier_state_28 character varying ,
    other_provider_identifier_issuer_28 character varying ,
    other_provider_identifier_29 character varying ,
    other_provider_identifier_type_code_29 character varying ,
    other_provider_identifier_state_29 character varying ,
    other_provider_identifier_issuer_29 character varying ,
    other_provider_identifier_30 character varying ,
    other_provider_identifier_type_code_30 character varying ,
    other_provider_identifier_state_30 character varying ,
    other_provider_identifier_issuer_30 character varying ,
    other_provider_identifier_31 character varying ,
    other_provider_identifier_type_code_31 character varying ,
    other_provider_identifier_state_31 character varying ,
    other_provider_identifier_issuer_31 character varying ,
    other_provider_identifier_32 character varying ,
    other_provider_identifier_type_code_32 character varying ,
    other_provider_identifier_state_32 character varying ,
    other_provider_identifier_issuer_32 character varying ,
    other_provider_identifier_33 character varying ,
    other_provider_identifier_type_code_33 character varying ,
    other_provider_identifier_state_33 character varying ,
    other_provider_identifier_issuer_33 character varying ,
    other_provider_identifier_34 character varying ,
    other_provider_identifier_type_code_34 character varying ,
    other_provider_identifier_state_34 character varying ,
    other_provider_identifier_issuer_34 character varying ,
    other_provider_identifier_35 character varying ,
    other_provider_identifier_type_code_35 character varying ,
    other_provider_identifier_state_35 character varying ,
    other_provider_identifier_issuer_35 character varying ,
    other_provider_identifier_36 character varying ,
    other_provider_identifier_type_code_36 character varying ,
    other_provider_identifier_state_36 character varying ,
    other_provider_identifier_issuer_36 character varying ,
    other_provider_identifier_37 character varying ,
    other_provider_identifier_type_code_37 character varying ,
    other_provider_identifier_state_37 character varying ,
    other_provider_identifier_issuer_37 character varying ,
    other_provider_identifier_38 character varying ,
    other_provider_identifier_type_code_38 character varying ,
    other_provider_identifier_state_38 character varying ,
    other_provider_identifier_issuer_38 character varying ,
    other_provider_identifier_39 character varying ,
    other_provider_identifier_type_code_39 character varying ,
    other_provider_identifier_state_39 character varying ,
    other_provider_identifier_issuer_39 character varying ,
    other_provider_identifier_40 character varying ,
    other_provider_identifier_type_code_40 character varying ,
    other_provider_identifier_state_40 character varying ,
    other_provider_identifier_issuer_40 character varying ,
    other_provider_identifier_41 character varying ,
    other_provider_identifier_type_code_41 character varying ,
    other_provider_identifier_state_41 character varying ,
    other_provider_identifier_issuer_41 character varying ,
    other_provider_identifier_42 character varying ,
    other_provider_identifier_type_code_42 character varying ,
    other_provider_identifier_state_42 character varying ,
    other_provider_identifier_issuer_42 character varying ,
    other_provider_identifier_43 character varying ,
    other_provider_identifier_type_code_43 character varying ,
    other_provider_identifier_state_43 character varying ,
    other_provider_identifier_issuer_43 character varying ,
    other_provider_identifier_44 character varying ,
    other_provider_identifier_type_code_44 character varying ,
    other_provider_identifier_state_44 character varying ,
    other_provider_identifier_issuer_44 character varying ,
    other_provider_identifier_45 character varying ,
    other_provider_identifier_type_code_45 character varying ,
    other_provider_identifier_state_45 character varying ,
    other_provider_identifier_issuer_45 character varying ,
    other_provider_identifier_46 character varying ,
    other_provider_identifier_type_code_46 character varying ,
    other_provider_identifier_state_46 character varying ,
    other_provider_identifier_issuer_46 character varying ,
    other_provider_identifier_47 character varying ,
    other_provider_identifier_type_code_47 character varying ,
    other_provider_identifier_state_47 character varying ,
    other_provider_identifier_issuer_47 character varying ,
    other_provider_identifier_48 character varying ,
    other_provider_identifier_type_code_48 character varying ,
    other_provider_identifier_state_48 character varying ,
    other_provider_identifier_issuer_48 character varying ,
    other_provider_identifier_49 character varying ,
    other_provider_identifier_type_code_49 character varying ,
    other_provider_identifier_state_49 character varying ,
    other_provider_identifier_issuer_49 character varying ,
    other_provider_identifier_50 character varying ,
    other_provider_identifier_type_code_50 character varying ,
    other_provider_identifier_state_50 character varying ,
    other_provider_identifier_issuer_50 character varying ,
    is_sole_proprietor character varying ,
    is_organization_subpart character varying ,
    parent_organization_lbn character varying ,
    parent_organization_tin character varying ,
    authorized_official_name_prefix_text character varying ,
    authorized_official_name_suffix_text character varying ,
    authorized_official_credential_text character varying ,
    healthcare_provider_taxonomy_group_1 character varying ,
    healthcare_provider_taxonomy_group_2 character varying ,
    healthcare_provider_taxonomy_group_3 character varying ,
    healthcare_provider_taxonomy_group_4 character varying ,
    healthcare_provider_taxonomy_group_5 character varying ,
    healthcare_provider_taxonomy_group_6 character varying ,
    healthcare_provider_taxonomy_group_7 character varying ,
    healthcare_provider_taxonomy_group_8 character varying ,
    healthcare_provider_taxonomy_group_9 character varying ,
    healthcare_provider_taxonomy_group_10 character varying ,
    healthcare_provider_taxonomy_group_11 character varying ,
    healthcare_provider_taxonomy_group_12 character varying ,
    healthcare_provider_taxonomy_group_13 character varying ,
    healthcare_provider_taxonomy_group_14 character varying ,
    healthcare_provider_taxonomy_group_15 character varying ,
    certification_date character varying 
)

CREATE INDEX IF NOT EXISTS idx_nppes_npi_data_file_stg_npi
	ON public.nppes_npi_data_file_stg USING btree (npi);

CREATE TABLE IF NOT EXISTS nppes_file_load(
	nppes_file_load_id bigint GENERATED ALWAYS AS IDENTITY,
	file_name VARCHAR(150),
	file_type VARCHAR(50),
	file_path VARCHAR(150),
	uploaded_date DATE DEFAULT CURRENT_DATE,
	last_uploaded_date TIMESTAMP DEFAULT now(),
	CONSTRAINT pk_nppes_file_load_id PRIMARY KEY (nppes_file_load_id)
)

INSERT INTO nppes_file_load (file_name,file_type,file_path) VALUES
('npidata_pfile_20240902-20240908.csv','NPPES MONTHLY','C:/Program Files/PostgreSQL/17/data/nppes/');

select * from nppes_file_load;

-- CALL nppes_file_load(1);

-- DROP PROCEDURE IF EXISTS public.nppes_file_load(bigint);

CREATE OR REPLACE PROCEDURE public.nppes_file_load(
	IN in_nppes_file_load_id bigint)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE 
    full_file_path TEXT;
    err_state TEXT; err_message TEXT; err_detail TEXT; 
	err_hint TEXT; err_context TEXT;
BEGIN
    -- DROP INDEX
    DROP INDEX IF EXISTS idx_nppes_npi_data_file_stg_npi;

    -- TRUNCATE TABLE
    TRUNCATE TABLE nppes_npi_data_file_stg;

    -- Fetch the file path dynamically based on the input parameter
    SELECT CONCAT(file_path, file_name) INTO full_file_path
    FROM nppes_file_load WHERE nppes_file_load_id = in_nppes_file_load_id;

    -- Perform the COPY command
    EXECUTE format(
        'COPY nppes_npi_data_file_stg FROM %L DELIMITER '','' CSV HEADER;',
        full_file_path);

    -- Update last_uploaded_date for the specified file load ID
    UPDATE nppes_file_load 
    SET last_uploaded_date = now() WHERE nppes_file_load_id = in_nppes_file_load_id;

    -- Create the index if it does not exist
    CREATE INDEX IF NOT EXISTS idx_nppes_npi_data_file_stg_npi
        ON public.nppes_npi_data_file_stg USING btree (npi);

    -- Log success
    RAISE NOTICE 'RESULT FILE LOAD COMPLETED: %', full_file_path;

EXCEPTION
    WHEN OTHERS THEN
        -- Capture exception details
        GET STACKED DIAGNOSTICS err_state = RETURNED_SQLSTATE,
                                err_message = MESSAGE_TEXT,
                                err_detail = PG_EXCEPTION_DETAIL,
                                err_hint = PG_EXCEPTION_HINT,
                                err_context = PG_EXCEPTION_CONTEXT;

        -- Handle the exception
        RAISE WARNING 'An error occurred: %', err_message;

        -- Optionally, log error details for debugging
        RAISE NOTICE 'Error State: %, Detail: %, Hint: %, Context: %', 
                     err_state, err_detail, err_hint, err_context;
END;
$BODY$;