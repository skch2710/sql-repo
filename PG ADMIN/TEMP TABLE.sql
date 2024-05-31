BEGIN;

-- Create a temporary table that will be dropped at the end of the transaction
CREATE TEMP TABLE temp_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
) ON COMMIT DROP;

-- Insert some data into the temporary table
INSERT INTO temp_table (name) VALUES ('Alice'), ('Bob'), ('Charlie');

-- Select data from the temporary table
SELECT * FROM temp_table;

-- DROP TEMP TEBLE
DROP TABLE IF EXISTS temp_table;

-- Commit the transaction
COMMIT;

-- Attempting to select from the temporary table after the transaction will result in an error
-- because the table has been dropped
SELECT * FROM temp_table; -- This will fail


/******************************************/


BEGIN;

CREATE TEMP TABLE temp_table ON COMMIT DROP AS 
SELECT * FROM hostel.hostellers;

SELECT * FROM temp_table;

COMMIT;
