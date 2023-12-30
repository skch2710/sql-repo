
create schema file_upload;

create table file_upload.file_upload (
    file_id bigint GENERATED ALWAYS AS IDENTITY,
    file_name VARCHAR(150),
	file_type VARCHAR(150),
	file_data bytea,
	CONSTRAINT file_upload_pkey PRIMARY KEY (file_id)
)

------ Employee Table ---- 

CREATE TABLE IF NOT EXISTS login.employees
(
    emp_id bigint GENERATED ALWAYS AS IDENTITY,
    email_id VARCHAR(255) NOT NULL UNIQUE,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    password_salt VARCHAR(255),
	created_by_id bigint,
    created_date TIMESTAMP ,
    modified_by_id bigint,
    modified_date TIMESTAMP ,
    CONSTRAINT employees_pkey PRIMARY KEY (emp_id)
)

select * from login.employees


CREATE TABLE IF NOT EXISTS login.roles
(
    role_id bigint,
    role_name VARCHAR(100) NOT NULL,
    is_active boolean,
    is_external_role boolean,
    is_custom_role boolean,
    note text,
    created_by_id bigint,
    created_date TIMESTAMP,
    modified_by_id bigint,
    modified_date TIMESTAMP,
    display_seq integer,
    CONSTRAINT roles_pkey PRIMARY KEY (role_id)
)

select * from login.roles

INSERT INTO login.roles ("role_id","role_name","is_active","is_external_role","is_custom_role","note","created_by_id","created_date","modified_by_id","modified_date","display_seq")
VALUES
(1,'Super User',True,False,False,'Internal Super User',1,'2023-07-14 16:35:08',1,'2023-07-14 16:35:08',1),
(2,'Admin',True,True,False,'External Admin',1,'2023-07-14 16:35:08',1,'2023-07-14 16:35:08',2);


CREATE TABLE IF NOT EXISTS login.emp_roles
(
    emp_role_id bigint GENERATED ALWAYS AS IDENTITY,
    emp_id bigint,
    role_id bigint,
    role_start_date TIMESTAMP,
    role_end_date TIMESTAMP,
    is_active boolean,
    created_by_id bigint,
    created_date TIMESTAMP,
    modified_by_id bigint,
    modified_date TIMESTAMP,
    is_deleted boolean,
    CONSTRAINT emp_roles_pkey PRIMARY KEY (emp_role_id)
)

select * from login.emp_roles


------------ View Creation ----------------------


select * from login.vw_employees

CREATE VIEW login.vw_employees AS
select e.emp_id,
e.email_id,
e.first_name,
e.last_name,
e.created_by_id,
er.emp_role_id,
r.role_id,
r.role_name,
r.is_external_role
from login.employees e LEFT JOIN login.emp_roles er ON e.emp_id=er.emp_id 
LEFT JOIN login.roles r ON r.role_id = er.role_id
;

-------------This Is For Oauth----------------------

drop table public.oauth_client_details

CREATE TABLE public.oauth_client_details (
	client_id varchar NOT NULL,
	resource_ids varchar NULL,
	client_secret varchar NOT NULL,
	"scope" varchar NULL,
	authorized_grant_types varchar NULL,
	web_server_redirect_uri varchar NULL,
	authorities varchar NULL,
	access_token_validity varchar NULL,
	refresh_token_validity varchar NULL,
	additional_information varchar NULL,
	autoapprove varchar NULL
);


INSERT INTO public.oauth_client_details
(client_id, resource_ids, client_secret, "scope", authorized_grant_types, web_server_redirect_uri, authorities, access_token_validity, refresh_token_validity, additional_information, autoapprove)
VALUES('sathish_ch', NULL, '$2a$12$6DF8tgBS4kxjuED6B4WSEOx9559QPcfl/ioE5i2sJQYVHmqjU/rQO', 'read,write', 'password,refresh_token,client_credentials', NULL, 'ROLE_CLIENT', '86400', '172800', NULL, NULL);