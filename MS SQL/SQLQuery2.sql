CREATE TABLE employee (
    id int IDENTITY(1,1) PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT
);

CREATE TABLE address (
    id int IDENTITY(1,1) PRIMARY KEY,
    employee_id INTEGER REFERENCES employee(id),
    street TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT
);

-- Declare a table variable to hold the inserted ID
DECLARE @NewEmployeeID TABLE (id INT);

-- Insert into employee and capture the new ID
INSERT INTO employee (first_name, last_name, email)
OUTPUT INSERTED.id INTO @NewEmployeeID
VALUES ('test', 'test', 'test');

-- Insert into address using the captured ID
INSERT INTO address (employee_id, street, city, state, zip_code)
SELECT id, '123 Main St', 'Sample City', 'CA', '12345'
FROM @NewEmployeeID;


---------------

select * from employee;

select * from address;

