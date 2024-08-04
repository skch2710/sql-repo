-- DROP TABLE IF EXISTS users_stg;

CREATE TABLE users_stg (
	users_stg_id bigint GENERATED ALWAYS AS IDENTITY,
	first_name text ,
	last_name text ,
	email_id text,
	phone_number text,
	dob text,
	role_name text,
	upload_file_id bigint,
	status varchar(10),
	error_message text,
	user_id bigint,
	CONSTRAINT users_stg_pk PRIMARY KEY (users_stg_id)
)

-- DROP TABLE IF EXISTS upload_file;

CREATE TABLE upload_file (
	upload_file_id bigint GENERATED ALWAYS AS IDENTITY,
	file_name VARCHAR(50),
	upload_type VARCHAR(25),
	uploaded_by_id BIGINT,
	uploaded_date TIMESTAMP DEFAULT NOW(),
	status_id INTEGER,
	total_count BIGINT,
	success_count BIGINT,
	failure_count BIGINT,
	is_mail_sent CHAR(1) DEFAULT 'N',
	CONSTRAINT users_file_pk PRIMARY KEY (upload_file_id)
)


select * from upload_file;

select * from users_stg;

select * from hostel.users;
select * from hostel.user_roles;
select * from hostel.user_privileges where user_id in (14);

select * from fn_validate_users_stg(2);

CALL proc_validate_users_stg(1);

