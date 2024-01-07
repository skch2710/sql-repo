create table hostel.hostellers(
	hosteller_id BIGINT GENERATED ALWAYS AS IDENTITY,
	full_name VARCHAR(250),
	email_id VARCHAR(150) NOT NULL UNIQUE,
	pnome_number VARCHAR(150),
	fee NUMERIC(14,2) NOT NULL,
	joining_date TIMESTAMP,
	address TEXT,
	proof TEXT,
	reason VARCHAR(250),
	vacated_date TIMESTAMP,
	active BOOLEAN DEFAULT true,
	created_by_id BIGINT,
    created_date TIMESTAMP,
    modified_by_id BIGINT,
    modified_date TIMESTAMP,
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