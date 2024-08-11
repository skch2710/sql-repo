create schema hostel;

CREATE TABLE hostel.hostellers(
	hosteller_id BIGINT GENERATED ALWAYS AS IDENTITY,
	full_name VARCHAR(250),
	email_id VARCHAR(150) NOT NULL UNIQUE,
	phone_number VARCHAR(150),
	dob DATE DEFAULT NULL,
	fee NUMERIC(14,2) NOT NULL,
	joining_date TIMESTAMP,
	address TEXT,
	proof TEXT,
	reason VARCHAR(250),
	vacated_date TIMESTAMP,
	active BOOLEAN DEFAULT true,
	created_by_id BIGINT,
    created_date TIMESTAMP DEFAULT NOW(),
    modified_by_id BIGINT,
    modified_date TIMESTAMP DEFAULT NOW(),
CONSTRAINT hostellers_pkey PRIMARY KEY (hosteller_id)
)

select * from hostel.hostellers;

create table hostel.payment_history(
	payment_id BIGINT GENERATED ALWAYS AS IDENTITY,
	hosteller_id BIGINT NOT NULL,
	fee_paid NUMERIC(14,2) NOT NULL,
	fee_due NUMERIC(14,2),
	fee_date TIMESTAMP,
	payment_mode VARCHAR(250),
	created_by_id BIGINT,
    created_date TIMESTAMP,
    modified_by_id BIGINT,
    modified_date TIMESTAMP,
CONSTRAINT payment_history_pkey PRIMARY KEY (payment_id)
)

select * from hostel.payment_history;


select * from hostel.hostellers h left join hostel.payment_history ph on ph.hosteller_id = h.hosteller_id;


WITH LatestPaymentCTE AS (
  SELECT
    hosteller_id,
    MAX(payment_id) AS latest_payment_id
  FROM
    hostel.payment_history
  GROUP BY
    hosteller_id
)
SELECT
  lp.latest_payment_id,
  h.hosteller_id,
  ph.fee_paid,
  ph.fee_due,
  ph.fee_date,
  h.full_name,
  h.email_id
FROM
  hostel.hostellers h
LEFT JOIN
  LatestPaymentCTE lp ON h.hosteller_id = lp.hosteller_id
LEFT JOIN
  hostel.payment_history ph ON lp.latest_payment_id = ph.payment_id;

-------------------------------------------

CREATE TABLE hostel.users
(
    user_id bigint IDENTITY(1,1),
	first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_id VARCHAR(255) NOT NULL UNIQUE,
	password_salt VARCHAR(255),
	phone_number VARCHAR(50),
	dob DATE,
	mail_uuid VARCHAR(150),
	user_uuid VARCHAR(150),
	is_active CHAR(1) DEFAULT 'N',
	last_login_date DATETIME,
	last_password_reset_date DATETIME,
	created_by_id bigint,
    created_date DATETIME ,
    modified_by_id bigint,
    modified_date DATETIME ,
    CONSTRAINT users_pkey PRIMARY KEY (user_id)
);

select * from hostel.users;


CREATE TABLE hostel.roles
(
    role_id bigint,
    role_name VARCHAR(100) NOT NULL,
    is_active CHAR(1) DEFAULT 'N',
    is_external_role CHAR(1) DEFAULT 'N',
    note text,
    created_by_id bigint,
    created_date DATETIME,
    modified_by_id bigint,
    modified_date DATETIME,
    CONSTRAINT h_roles_pkey PRIMARY KEY (role_id)
);


select * from hostel.roles;

INSERT INTO hostel.roles VALUES 
(1,'Super User','Y','N','Internal Super User',1,GETDATE(),1,GETDATE()),
(2,'Admin','Y','Y','External Admin',1,GETDATE(),1,GETDATE());


CREATE TABLE hostel.user_roles
(
    user_role_id bigint IDENTITY(1,1),
    user_id bigint,
    role_id bigint,
    is_active CHAR(1) DEFAULT 'Y',
    created_by_id bigint,
    created_date datetime,
    modified_by_id bigint,
    modified_date datetime,
    CONSTRAINT h_user_roles_pkey PRIMARY KEY (user_role_id)
);


select * from hostel.user_roles;

--DROP TABLE hostel.resource;
CREATE TABLE hostel.resource
(
    resource_id bigint,
	resource_name VARCHAR(250),
	resource_path VARCHAR(250),
	icon VARCHAR(250),
	display_order BIGINT,
	is_subnav CHAR(1),
	parent_name VARCHAR(250),
	parent_icon VARCHAR(250),
    is_active CHAR(1),
    CONSTRAINT h_resource_pkey PRIMARY KEY (resource_id)
);


select * from hostel.resource;

INSERT INTO hostel.resource(
	resource_id, resource_name, resource_path, icon, display_order, is_subnav,parent_name,parent_icon, is_active)
	VALUES (1, 'Home', '/home', 'home.png', 1, 'N','Home','home.png', 'Y'),
	(2, 'Full Reports', '/reports/full-reports', 'full-reports.png', 2, 'Y','Reports','reports.png', 'Y'),
	(3, 'Monthly', '/reports/monthly', 'monthly.png', 2, 'Y','Reports','reports.png', 'Y'),
	(4, 'Yearly', '/reports/yearly', 'yearly.png', 2, 'Y','Reports','reports.png', 'Y'),
	(5, 'Hostellers', '/hostellers', 'hostellers.png', 3, 'N','Hostellers','hostellers.png', 'Y'),
	(6, 'User', '/user', 'user.png', 4, 'N','User','user.png', 'Y');

CREATE TABLE hostel.user_privileges
(
    user_privileges_id bigint IDENTITY(1,1),
    user_id bigint,
    resource_id bigint,
	read_only_flag bit,
	read_write_flag bit,
	terminate_flag bit,
    is_active bit,
    created_by_id bigint,
    created_date datetime,
    modified_by_id bigint,
    modified_date datetime,
    CONSTRAINT h_user_privileges_pkey PRIMARY KEY (user_privileges_id)
);


select * from hostel.user_privileges;

CREATE TABLE hostel.role_privileges
(
    role_privileges_id bigint IDENTITY(1,1),
    role_id bigint,
    resource_id bigint,
	read_only_flag bit,
	read_write_flag bit,
	terminate_flag bit,
    is_active bit,
    created_by_id bigint,
    created_date datetime,
    modified_by_id bigint,
    modified_date datetime,
    CONSTRAINT h_role_privileges_pkey PRIMARY KEY (role_privileges_id)
);


select * from hostel.role_privileges;

INSERT INTO hostel.role_privileges(role_id, resource_id, read_only_flag, read_write_flag, terminate_flag, is_active,
	created_by_id, created_date, modified_by_id, modified_date)
	VALUES ( 1, 1, 1, 1, 1, 1, 1, getdate(), 1, getdate()),
		   ( 1, 2, 1, 1, 1, 1, 1, getdate(), 1, getdate()),
		   ( 1, 3, 1, 1, 1, 1, 1, getdate(), 1, getdate()),
		   ( 1, 4, 1, 1, 1, 1, 1, getdate(), 1, getdate()),
		   ( 1, 5, 1, 1, 1, 1, 1, getdate(), 1, getdate()),
		   ( 1, 6, 1, 1, 1, 1, 1, getdate(), 1, getdate()),
		   
		   ( 2, 1, 1, 0, 0, 1, 1, getdate(), 1, getdate()),
		   ( 2, 2, 1, 0, 0, 1, 1, getdate(), 1, getdate()),
		   ( 2, 3, 1, 0, 0, 1, 1, getdate(), 1, getdate()),
		   ( 2, 4, 1, 0, 0, 1, 1, getdate(), 1, getdate()),
		   ( 2, 5, 1, 1, 1, 1, 1, getdate(), 1, getdate()),
		   ( 2, 6, 0, 0, 0, 1, 1, getdate(), 1, getdate());



-----------

select * from hostel.users;
select * from hostel.roles;
select * from hostel.user_roles;
select * from hostel.resource;
select * from hostel.user_privileges where user_id=1;
select * from hostel.role_privileges;


------ Inser User 

INSERT INTO hostel.users(
	 first_name, last_name, email_id, password_salt, phone_number, dob, mail_uuid, user_uuid, is_active, last_login_date,
	last_password_reset_date, created_by_id, created_date, modified_by_id, modified_date)
	VALUES ( 'system', 'user', 'systemuser@mail.com', '$2a$10$OeZfp.6TtOhTQgO8DaUw8OJV4cqxQ3fZdLjUDUb46ZD/S6Z3aW1zq', 
			'123456', getdate(), null,null, 'Y', getdate(), getdate(), 1, getdate(), 1, getdate());

INSERT INTO hostel.user_roles(
	 user_id, role_id, is_active, created_by_id, created_date, modified_by_id, modified_date)
	VALUES (1, 1, 'Y', 1, getdate(), 1, getdate());


INSERT INTO hostel.user_privileges(
	user_id, resource_id, read_only_flag, read_write_flag, terminate_flag, is_active, 
	created_by_id, created_date, modified_by_id, modified_date)
	VALUES (1, 1, 1, 1, 1, 1, 1, getdate(), 1, getdate()),
	(1, 2, 1, 1, 1, 1, 1, getdate(), 1, getdate()),
	(1, 3, 1, 1, 1, 1, 1, getdate(), 1, getdate()),
	(1, 4, 1, 1, 1, 1, 1, getdate(), 1, getdate()),
	(1, 5, 1, 1, 1, 1, 1, getdate(), 1, getdate()),
	(1, 6, 1, 1, 1, 1, 1, getdate(), 1, getdate());

