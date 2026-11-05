SELECT 'seed' AS g, flags FROM (SELECT pg_settings_get_flags('transaction_isolation') AS flags) s;
BEGIN;
SELECT 1;
RESET transaction_isolation;
ROLLBACK;
CREATE FUNCTION f() RETURNS int LANGUAGE sql SET transaction_read_only = on AS 'select 1';
SELECT f();
RESET seed;
