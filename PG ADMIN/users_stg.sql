-- DROP TABLE IF EXISTS users_stg;


CREATE TABLE IF NOT EXISTS hostel.users_file_data
(
    users_file_data_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
    first_name character varying,
    last_name character varying,
    email_id character varying,
    phone_number character varying,
    dob character varying,
	role_name character varying,
    is_active character varying,
	upload_file_id bigint,
    status character varying(10),
    error_message character varying,
    user_id bigint,
    CONSTRAINT users_file_data_pkey PRIMARY KEY (users_file_data_id)
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

CREATE TABLE IF NOT EXISTS hostel.file_status
(
    status_id integer NOT NULL,
    status character varying(25) NOT NULL,
    created_by_id bigint,
    created_date timestamp without time zone DEFAULT now(),
    modified_by_id bigint,
    modified_date timestamp without time zone  DEFAULT now(),
    CONSTRAINT file_status_pkey PRIMARY KEY (status_id)
)

INSERT INTO hostel.file_status(
	status_id, status, created_by_id, modified_by_id)
	VALUES (1,'In-Progres' ,1 ,1 ),
		(2,'Completed' ,1 ,1 );

SELECT * FROM hostel.file_status;

select * from upload_file;

select * from hostel.users_file_data where upload_file_id=7;

select * from hostel.users;
select * from hostel.user_roles;
select * from hostel.user_privileges where user_id in (22);

--select * from proc_validate_users_data(5);

CALL proc_validate_users_data(5);

SELECT fn.insrted_new_user_id FROM fn_insert_user_with_details('Test1'
			,'test2' ,'testOnemail@gmail.com' ,'123455','12101996'
			,'Super User' ,1 ) fn;

/******************************/
select * from public.upload_file order by 1 desc; --9

select * from hostel.users_file_data where upload_file_id = 9;

delete from hostel.user_privileges where user_id in 
	(select user_id from hostel.users_file_data where upload_file_id = 9 and status= 'success' );    

delete from hostel.user_roles where user_id in 
	(select user_id from hostel.users_file_data where upload_file_id = 9 and status= 'success' );

delete from hostel.users where user_id in 
	(select user_id from hostel.users_file_data where upload_file_id = 9 and status= 'success' );

delete from hostel.users_file_data where upload_file_id = 9;
