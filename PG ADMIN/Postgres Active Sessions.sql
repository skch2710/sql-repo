SELECT datname,pid,state,query ,
age(clock_timestamp(),query_start) as age
FROM pg_stat_activity WHERE state <> 'idle'
ORDER BY age;

SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE pid in (14404);