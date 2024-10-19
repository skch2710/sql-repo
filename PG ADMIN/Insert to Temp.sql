BEGIN;

DO $$
DECLARE 
    in_params bigint[] := '{}';  -- Declare an array to hold all inserted temp_id values, initialized as an empty array
    rec RECORD; -- Declare a record to iterate over the inserted rows
BEGIN
    -- Create temp table if not exists
    CREATE TEMP TABLE IF NOT EXISTS temp_data(
        temp_id bigint primary key GENERATED ALWAYS AS IDENTITY,
        full_name VARCHAR(50)
    ); -- ON COMMIT DROP

    -- Create another temp table to store output
	DROP TABLE IF EXISTS temp_data_out;
    CREATE TEMP TABLE IF NOT EXISTS temp_data_out(
        temp_id bigint primary key,
        full_name VARCHAR(50)
    );

    -- Insert into temp_data and use RETURNING to capture each inserted row
    FOR rec IN
        INSERT INTO temp_data (full_name)
        VALUES ('test'), ('test2')
        RETURNING temp_id, full_name
    LOOP
        -- Insert the returned data into temp_data_out
        INSERT INTO temp_data_out (temp_id, full_name)
        VALUES (rec.temp_id, rec.full_name);

        -- Append each temp_id to the in_params array
        in_params := array_append(in_params, rec.temp_id);
    END LOOP;

    -- Now in_params holds all the inserted temp_ids
    RAISE NOTICE 'The values of in_params are: %', in_params;

END $$;

COMMIT;


--SELECT * FROM temp_data_out;
