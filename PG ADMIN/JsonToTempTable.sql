--Multiple Json Data

-- DROP FUNCTION process_json_data_set(TEXT)

CREATE OR REPLACE FUNCTION process_json_data_set(json_input TEXT)
RETURNS TABLE (data_id INT, full_name TEXT, email_id TEXT) 
AS $$
	/**
	SELECT * FROM process_json_data_set('[
    {"data_id": 1, "full_name": "John Doe", "email_id": "john.doe@example.com"},
    {"data_id": 2, "full_name": "Jane Smith", "email_id": "jane.smith@example.com"}
		]');
	*/
BEGIN
    -- Create temporary table
    CREATE TEMP TABLE temp_users (
        data_id INT,
        full_name TEXT,
        email_id TEXT
    ) ON COMMIT DROP;

    -- Insert JSON data into the temporary table
    INSERT INTO temp_users
    SELECT *
    FROM json_populate_recordset(NULL::temp_users, json_input::json);

    -- Return the result set from the temporary table
    RETURN QUERY SELECT * FROM temp_users;
END;
$$ LANGUAGE plpgsql;

--Single Record

-- DROP FUNCTION process_json_data(TEXT)

CREATE OR REPLACE FUNCTION process_json_data(json_input TEXT)
RETURNS TABLE (data_id INT, full_name TEXT, email_id TEXT) 
AS $$
	/**
	SELECT * FROM process_json_data('{"data_id": 1, "full_name": "", 
		"email_id": "john.doe@example.com"}');
	*/
BEGIN
    -- Create temporary table
    CREATE TEMP TABLE temp_user (
        data_id INT,
        full_name TEXT,
        email_id TEXT
    ) ON COMMIT DROP;

    -- Insert JSON data into the temporary table
    INSERT INTO temp_user
    SELECT *
    FROM json_populate_record(NULL::temp_user, json_input::json);

    -- Return the result set from the temporary table
    RETURN QUERY SELECT * FROM temp_user;
END;
$$ LANGUAGE plpgsql;


-- Using composite Type
CREATE OR REPLACE FUNCTION process_json_data_test(json_input TEXT)
RETURNS TABLE (id INT, name TEXT, email TEXT) 
AS $$
    /**
    SELECT * FROM process_json_data_test('{"id": 1, "name": "John Doe", "email": "john.doe@example.com"}');
    */
BEGIN
    -- Define a composite type
    CREATE TYPE temp_user_type AS (
        id INT,
        name TEXT,
        email TEXT
    );

    -- Return the result set from the temporary table
    RETURN QUERY
    SELECT * FROM json_populate_record(NULL::temp_user_type, json_input::json);

    -- Drop the composite type
   DROP TYPE temp_user_type;
END;
$$ LANGUAGE plpgsql;


--Table Data To Json Object as Map<>

select * from hostel.resource;

SELECT json_object_agg(resource_id, resource_name)::text AS json_data
FROM hostel.resource WHERE resource_id in (1,2,6);

SELECT json_object_agg(r.resource_id, json_build_object(
	'resourceId',r.resource_id,
	'resourceName', r.resource_name,
	'testName',u.email_id )) AS json_data
FROM hostel.resource r JOIN hostel.users u ON r.display_order = u.user_id
	WHERE r.resource_id in (1,2);

--List of Objects Json

SELECT json_agg(json_build_object(
	'resourceId',r.resource_id,
	'resourceName', r.resource_name,
	'testName', r.parent_name
	))::text AS data_json
FROM hostel.resource r WHERE r.resource_id in (1,2);

SELECT CAST(json_object_agg(up.resource_id, r.resource_name)::TEXT AS bytea) AS data_json
FROM hostel.user_privileges up 
JOIN hostel.resource r ON up.resource_id = r.resource_id
WHERE up.user_id =1;


SELECT json_object_agg(hosteller_id,email_id) AS data_json
FROM hostel.hostellers;

SELECT CAST(CAST(json_object_agg(hosteller_id,email_id) AS TEXT) AS bytea) AS data_json
FROM hostel.hostellers;

select * from hostel.hostellers


SELECT json_build_object('minDob', MIN(dob),'maxDob', MAX(dob)) AS dob_range
FROM hostel.hostellers;

SELECT json_build_object('minDob', TO_CHAR(MIN(dob),'MM/dd/yyyy'),'maxDob',
TO_CHAR(MAX(dob),'MM/dd/yyyy')) AS dob_range FROM hostel.hostellers;


-------- JSON to Temp Table JSONB ------------

DO $$
DECLARE
    json_input JSONB := '[
        {
            "firstName": "John",
            "lastName": "Doe",
            "email": "john.doe@example.com",
            "age": 28,
            "dob": "1995-05-15"
        },
        {
            "firstName": "Jane",
            "lastName": "Smith",
            "email": "jane.smith@example.com",
            "age": 34,
            "dob": "1989-11-22"
        },
        {
            "firstName": "Alice",
            "lastName": "Johnson",
            "email": "alice.johnson@example.com",
            "age": 42,
            "dob": "1981-03-10"
        }
    ]'::JSONB;
BEGIN
    -- Create a temporary table
    CREATE TEMP TABLE tmp_input_data (
        id SERIAL PRIMARY KEY,
        first_name TEXT,
        last_name TEXT,
        email TEXT,
        age INT,
        dob DATE
    ); --ON COMMIT DROP;

    -- Insert data from the JSON array into the temporary table
    INSERT INTO tmp_input_data (first_name, last_name, email, age, dob)
    SELECT
        elem ->> 'firstName' AS first_name,
        elem ->> 'lastName' AS last_name,
        elem ->> 'email' AS email,
        (elem ->> 'age')::INT AS age,
        (elem ->> 'dob')::DATE AS dob
    FROM jsonb_array_elements(json_input) AS elem;

    -- Select and display the inserted data
    RAISE NOTICE 'Inserted data:';

END $$;

-- SELECT * FROM tmp_input_data;
