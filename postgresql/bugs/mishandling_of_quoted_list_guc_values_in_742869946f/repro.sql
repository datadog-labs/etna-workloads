CREATE FUNCTION f() RETURNS int LANGUAGE sql SET local_preload_libraries TO 'Mixed/Case', 'a b' AS 'select 1';
SELECT pg_get_functiondef('f()'::regprocedure);
