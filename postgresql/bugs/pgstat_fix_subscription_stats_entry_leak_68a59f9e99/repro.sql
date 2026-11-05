CREATE SUBSCRIPTION s1 CONNECTION 'dbname=nonexistent' PUBLICATION p WITH (connect=false);
SELECT oid AS soid FROM pg_subscription WHERE subname='s1' \gset
SELECT pg_stat_have_stats('subscription', 0, :soid);
ALTER SUBSCRIPTION s1 SET (slot_name = NONE);
DROP SUBSCRIPTION s1;
SELECT pg_stat_have_stats('subscription', 0, :soid);
