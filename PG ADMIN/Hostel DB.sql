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

CREATE TABLE IF NOT EXISTS hostel.users
(
    user_id bigint GENERATED ALWAYS AS IDENTITY,
	first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_id VARCHAR(255) NOT NULL UNIQUE,
	password_salt VARCHAR(255),
	phone_number VARCHAR(50),
	dob DATE,
	mail_uuid VARCHAR(150),
	user_uuid VARCHAR(150),
	is_active boolean,
	last_login_date TIMESTAMP,
	last_password_reset_date TIMESTAMP,
	created_by_id bigint,
    created_date TIMESTAMP ,
    modified_by_id bigint,
    modified_date TIMESTAMP ,
    CONSTRAINT users_pkey PRIMARY KEY (user_id)
);

select * from hostel.users;


CREATE TABLE IF NOT EXISTS hostel.roles
(
    role_id bigint,
    role_name VARCHAR(100) NOT NULL,
    is_active boolean,
    is_external_role boolean,
    note text,
    created_by_id bigint,
    created_date TIMESTAMP,
    modified_by_id bigint,
    modified_date TIMESTAMP,
    CONSTRAINT h_roles_pkey PRIMARY KEY (role_id)
);


select * from hostel.roles;

INSERT INTO hostel.roles VALUES 
(1,'Super User',true,false,'Internal Super User',1,now(),1,now()),
(2,'Admin',true,true,'External Admin',1,now(),1,now());


CREATE TABLE IF NOT EXISTS hostel.user_roles
(
    user_role_id bigint GENERATED ALWAYS AS IDENTITY,
    user_id bigint,
    role_id bigint,
    is_active boolean,
    created_by_id bigint,
    created_date TIMESTAMP,
    modified_by_id bigint,
    modified_date TIMESTAMP,
    CONSTRAINT h_user_roles_pkey PRIMARY KEY (user_role_id)
);


select * from hostel.user_roles;

--DROP TABLE hostel.resource;
CREATE TABLE IF NOT EXISTS hostel.resource
(
    resource_id bigint,
	resource_name VARCHAR(250),
	resource_path VARCHAR(250),
	icon VARCHAR(250),
	display_order BIGINT,
	is_subnav CHAR(1),
	parent_name VARCHAR(250),
	parent_icon VARCHAR(250),
    is_active boolean,
    CONSTRAINT h_resource_pkey PRIMARY KEY (resource_id)
);


select * from hostel.resource;

INSERT INTO hostel.resource(
	resource_id, resource_name, resource_path, icon, display_order, is_subnav,parent_name,parent_icon, is_active)
	VALUES (1, 'Home', '/home', 'home.png', 1, 'N','Home','home.png', true),
	(2, 'Full Reports', '/reports/full-reports', 'full-reports.png', 2, 'Y','Reports','reports.png', true),
	(3, 'Monthly', '/reports/monthly', 'monthly.png', 2, 'Y','Reports','reports.png', true),
	(4, 'Yearly', '/reports/yearly', 'yearly.png', 2, 'Y','Reports','reports.png', true),
	(5, 'Hostellers', '/hostellers', 'hostellers.png', 3, 'N','Hostellers','hostellers.png', true),
	(6, 'User', '/user', 'user.png', 4, 'N','User','user.png', true);

CREATE TABLE IF NOT EXISTS hostel.user_privileges
(
    user_privileges_id bigint GENERATED ALWAYS AS IDENTITY,
    user_id bigint,
    resource_id bigint,
	read_only_flag boolean,
	read_write_flag boolean,
	terminate_flag boolean,
    is_active boolean,
    created_by_id bigint,
    created_date TIMESTAMP,
    modified_by_id bigint,
    modified_date TIMESTAMP,
    CONSTRAINT h_user_privileges_pkey PRIMARY KEY (user_privileges_id)
);


select * from hostel.user_privileges;

CREATE TABLE IF NOT EXISTS hostel.role_privileges
(
    role_privileges_id bigint GENERATED ALWAYS AS IDENTITY,
    role_id bigint,
    resource_id bigint,
	read_only_flag boolean,
	read_write_flag boolean,
	terminate_flag boolean,
    is_active boolean,
    created_by_id bigint,
    created_date TIMESTAMP,
    modified_by_id bigint,
    modified_date TIMESTAMP,
    CONSTRAINT h_role_privileges_pkey PRIMARY KEY (role_privileges_id)
);


select * from hostel.role_privileges;

INSERT INTO hostel.role_privileges(role_id, resource_id, read_only_flag, read_write_flag, terminate_flag, is_active,
	created_by_id, created_date, modified_by_id, modified_date)
	VALUES ( 1, 1, true, true, true, true, 1, now(), 1, now()),
		   ( 1, 2, true, true, true, true, 1, now(), 1, now()),
		   ( 1, 3, true, true, true, true, 1, now(), 1, now()),
		   ( 1, 4, true, true, true, true, 1, now(), 1, now()),
		   ( 1, 5, true, true, true, true, 1, now(), 1, now()),
		   ( 1, 6, true, true, true, true, 1, now(), 1, now()),
		   
		   ( 2, 1, true, false, false, true, 1, now(), 1, now()),
		   ( 2, 2, true, false, false, true, 1, now(), 1, now()),
		   ( 2, 3, true, false, false, true, 1, now(), 1, now()),
		   ( 2, 4, true, false, false, true, 1, now(), 1, now()),
		   ( 2, 5, true, true, true, true, 1, now(), 1, now()),
		   ( 2, 6, false, false, false, true, 1, now(), 1, now());


------- User Validate


CREATE TABLE IF NOT EXISTS hostel.user_validation
(
    user_validation_id bigint GENERATED ALWAYS AS IDENTITY,
    user_id bigint,
	uuid_type varchar(50),
	uuid_link varchar(50),
    is_active char(1),
    created_by_id bigint,
    created_date timestamp without time zone DEFAULT now(),
    modified_by_id bigint,
    modified_date timestamp without time zone DEFAULT now(),
    CONSTRAINT h_user_validation_pkey PRIMARY KEY (user_validation_id)
)

/*
SELECT EXISTS (
    SELECT 1
    FROM hostel.user_validation
    WHERE create_pwd_uuid = 'b8c2a603-f47e-4684-af90-dd348f702ea4#1724563024168'
       OR forgot_pwd_uuid = 'b8c2a603-f47e-4684-af90-dd348f702ea4#1724563024168'
       OR reset_pwd_uuid = 'b8c2a603-f47e-4684-af90-dd348f702ea4#1724563024168'
) AS is_present; */

SELECT EXISTS (SELECT 1 FROM hostel.user_validation WHERE create_pwd_uuid = :uuid
       OR forgot_pwd_uuid = :uuid OR reset_pwd_uuid = :uuid ) AS is_present;

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
	VALUES ( 'system', 'user', 'skch@outlook.com', '$2a$10$1oZeYehKZTCtx8titPu.oOHFMfd/X86SJltkEew4OIwFeY/8kGQVu', 
			'123456', now(), null,null, true, now(), now(), 1, now(), 1, now());

INSERT INTO hostel.user_roles(
	 user_id, role_id, is_active, created_by_id, created_date, modified_by_id, modified_date)
	VALUES (1, 1, true, 1, now(), 1, now());


INSERT INTO hostel.user_privileges(
	user_id, resource_id, read_only_flag, read_write_flag, terminate_flag, is_active, 
	created_by_id, created_date, modified_by_id, modified_date)
	VALUES (1, 1, true, true, true, true, 1, now(), 1, now()),
	(1, 2, true, true, true, true, 1, now(), 1, now()),
	(1, 3, true, true, true, true, 1, now(), 1, now()),
	(1, 4, true, true, true, true, 1, now(), 1, now()),
	(1, 5, true, true, true, true, 1, now(), 1, now()),
	(1, 6, true, true, true, true, 1, now(), 1, now());

