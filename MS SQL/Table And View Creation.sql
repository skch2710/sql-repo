
/* ** File Upload Table ** */
create schema file_upload;

create table file_upload.file_upload (
    file_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    file_name VARCHAR(150),
	file_type VARCHAR(150),
	file_data VARBINARY(MAX)
)

select * from file_upload.file_upload;

/* ** Employee Table ** */
create schema login;

CREATE TABLE login.employees
(
    emp_id BIGINT IDENTITY(1,1),
    email_id VARCHAR(150) NOT NULL UNIQUE,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    password_salt VARCHAR(150),
	created_by_id BIGINT,
    created_date DATETIME2(7) ,
    modified_by_id BIGINT,
    modified_date DATETIME2(7) ,
    CONSTRAINT employees_pkey PRIMARY KEY (emp_id)
)

select * from login.employees;


CREATE TABLE login.roles
(
    role_id BIGINT NOT NULL,
    role_name VARCHAR(150) NOT NULL,
    is_active BIT,
    is_external_role BIT,
    is_custom_role BIT,
    note VARCHAR(150) ,
    created_by_id BIGINT,
    created_date DATETIME2(7),
    modified_by_id BIGINT,
    modified_date DATETIME2(7),
    display_seq INTEGER,
    CONSTRAINT roles_pkey PRIMARY KEY (role_id)
)

select * from login.roles

INSERT INTO login.roles ("role_id","role_name","is_active","is_external_role","is_custom_role","note","created_by_id","created_date","modified_by_id","modified_date","display_seq")
VALUES
(1,'Super User',1,0,0,'Internal Super User',1,'2023-07-14 16:35:08',1,'2023-07-14 16:35:08',1),
(2,'Admin',1,1,0,'External Admin',1,'2023-07-14 16:35:08',1,'2023-07-14 16:35:08',2);


CREATE TABLE login.emp_roles
(
    emp_role_id BIGINT IDENTITY(1,1),
    emp_id BIGINT,
    role_id BIGINT,
    role_start_date DATETIME2(7),
    role_end_date DATETIME2(7),
    is_active BIT,
    created_by_id BIGINT,
    created_date DATETIME2(7),
    modified_by_id BIGINT,
    modified_date DATETIME2(7),
    is_deleted BIT,
    CONSTRAINT emp_roles_pkey PRIMARY KEY (emp_role_id)
)

select * from login.emp_roles


--------------- CREATING VIEW ------------------------


select * from login.vw_employees;

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
