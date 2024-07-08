-- Create a temporary table
CREATE TABLE #temp_user (
    id INT,
    name NVARCHAR(255),
    email NVARCHAR(255)
);

-- JSON input
DECLARE @json_input NVARCHAR(MAX) = '[
    {"id": 1, "name": "John Doe", "email": "john.doe@example.com"},
    {"id": 2, "name": "Jane Smith", "email": "jane.smith@example.com"}
]';

-- Insert JSON data into the temporary table
INSERT INTO #temp_user (id, name, email)
SELECT id, name, email
FROM OPENJSON(@json_input)
WITH (
    id INT,
    name NVARCHAR(255),
    email NVARCHAR(255)
);

-- Verify the inserted data
SELECT * FROM #temp_user;

-- Drop the temporary table (optional, as it will be dropped automatically at the end of the session)
DROP TABLE #temp_user;

--Table to Map

SELECT 
    '{' + STRING_AGG('"' + CAST(id AS VARCHAR(MAX)) + '":"' + email + '"', ',') + '}' AS data_json
FROM #temp_user;



