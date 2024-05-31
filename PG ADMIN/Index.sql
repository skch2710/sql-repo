/* 
Indexes in PostgreSQL are a powerful feature designed to improve the speed and efficiency of database queries.
*/

CREATE INDEX idx_column_name
ON table_name USING btree (column_name);

CREATE INDEX IF NOT EXISTS idx_payment_history_hosteller_id
	ON hostel.payment_history USING btree (hosteller_id);
	
select * from hostel.payment_history where hosteller_id=4;

DROP INDEX IF EXISTS hostel.idx_payment_history_hosteller_id;

SELECT indexname, schemaname, tablename
FROM pg_indexes
WHERE indexname = 'idx_payment_history_hosteller_id';

