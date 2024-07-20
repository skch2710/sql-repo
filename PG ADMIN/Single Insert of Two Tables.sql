CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT
);

CREATE TABLE address (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employee(id),
    street TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT
);

WITH new_employee_id AS (
    INSERT INTO employee (first_name, last_name, email)
    VALUES ('test', 'test', 'test')
    RETURNING id
)
INSERT INTO address (employee_id, street, city, state, zip_code)
SELECT id, 'addr.street', 'addr.city', 'addr.state', 'addr.zip_code'
FROM new_employee_id;


select * from address;




