CREATE SUBSCRIPTION s CONNECTION 'dbname=nonexist' PUBLICATION p WITH (connect=false);
ALTER SUBSCRIPTION s SET (run_as_owner = true);
SELECT subrunasowner FROM pg_subscription WHERE subname='s';
DROP SUBSCRIPTION s;
