

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

select uuid_generate_v4();

SELECT (EXTRACT(EPOCH FROM NOW()) * 1000)::BIGINT AS current_time_milliseconds;

select CONCAT(uuid_generate_v4(),'#',(EXTRACT(EPOCH FROM NOW()) * 1000)::BIGINT)

select CONCAT(uuid_generate_v4(),'#',(EXTRACT(EPOCH FROM now() - INTERVAL '1 day') * 1000)::BIGINT);

select CONCAT(uuid_generate_v4(),'#',(EXTRACT(EPOCH FROM now() - INTERVAL '4 hours') * 1000)::BIGINT);

select * from hostel.user_validation;

SELECT now() + INTERVAL '1 day';


SELECT now() + INTERVAL '24 hours';


