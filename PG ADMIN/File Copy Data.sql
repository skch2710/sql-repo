SHOW data_directory;

SELECT * FROM 
    pg_catalog.pg_ls_dir('C:/Program Files/PostgreSQL/16/data/tempfiles');

SELECT * FROM pg_catalog.pg_read_file('C:/Program Files/PostgreSQL/16/data/tempfiles/largeOne_1728118838673.csv');

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




