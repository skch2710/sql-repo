--Multiple Json Data

CREATE OR REPLACE FUNCTION process_json_data_set(json_input TEXT)
RETURNS TABLE (id INT, name TEXT, email TEXT) 
AS $$
	/**
	SELECT * FROM process_json_data_set('[
    {"id": 1, "name": "John Doe", "email": "john.doe@example.com"},
    {"id": 2, "name": "Jane Smith", "email": "jane.smith@example.com"}
		]');
	*/
BEGIN
    -- Create temporary table
    CREATE TEMP TABLE temp_users (
        id INT,
        name TEXT,
        email TEXT
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

CREATE OR REPLACE FUNCTION process_json_data(json_input TEXT)
RETURNS TABLE (id INT, name TEXT, email TEXT) 
AS $$
	/**
	SELECT * FROM process_json_data('{"id": 1, "name": "", "email": "john.doe@example.com"}');
	*/
BEGIN
    -- Create temporary table
    CREATE TEMP TABLE temp_user (
        id INT,
        name TEXT,
        email TEXT
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
	'testName',u.email_id ))::text AS json_data
FROM hostel.resource r JOIN hostel.users u ON r.display_order = u.user_id
	WHERE r.resource_id in (1,2);

--List of Objects Json

SELECT json_agg(json_build_object(
	'resourceId',r.resource_id,
	'resourceName', r.resource_name,
	'testName', r.parent_name
	))::text AS data_json
FROM hostel.resource r WHERE r.resource_id in (1,2);
