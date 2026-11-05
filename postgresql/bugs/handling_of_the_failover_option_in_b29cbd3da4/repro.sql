CREATE SUBSCRIPTION s1 CONNECTION 'dbname=nonexistent' PUBLICATION p WITH (connect=false, failover=true);
BEGIN;
ALTER SUBSCRIPTION s1 SET (failover = false);
ROLLBACK;
SELECT subfailover FROM pg_subscription WHERE subname='s1';
DROP SUBSCRIPTION s1;
