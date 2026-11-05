\set VERBOSITY terse
CREATE SUBSCRIPTION s1 CONNECTION 'dbname=doesnotexist' PUBLICATION p WITH (slot_name = NONE);
CREATE SUBSCRIPTION s1 CONNECTION 'dbname=doesnotexist' PUBLICATION p WITH (slot_name = NONE, enabled = false);
SELECT count(*) FROM pg_subscription;
