
CREATE INDEX idx_email_id
ON [emp].[employees] (email_id);

--DROP INDEX index_name ON table_name;

DROP INDEX idx_email_id ON [emp].[employees];

CREATE INDEX idx_email_id_salary
ON [emp].[employees] (email_id,salary);