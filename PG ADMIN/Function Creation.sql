select * from login.employees;

select * from fn_employee_data();

-- DROP FUNCTION fn_employee_data();

CREATE OR REPLACE FUNCTION fn_employee_data()
RETURNS TABLE (rn_id BIGINT,emp_id BIGINT, email_id VARCHAR,first_name VARCHAR,last_name VARCHAR,created_by_id BIGINT,
			   emp_role_id BIGINT,role_id BIGINT,role_name VARCHAR,is_external_role boolean,total_count BIGINT)
AS $$
BEGIN
    RETURN QUERY
    	select ROW_NUMBER() OVER (ORDER BY (select 1)) AS rn_id,
		e.emp_id,e.email_id,e.first_name,e.last_name,e.created_by_id,
		er.emp_role_id,r.role_id,r.role_name,r.is_external_role,
		COUNT(1) OVER (PARTITION BY 1) AS total_count
		FROM login.employees e LEFT JOIN login.emp_roles er ON e.emp_id=er.emp_id 
	    LEFT JOIN login.roles r ON r.role_id = er.role_id;
END;
$$ LANGUAGE plpgsql;
