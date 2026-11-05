CREATE SUBSCRIPTION regress_testsub CONNECTION 'dbname=regress_doesnotexist' PUBLICATION testpub WITH (connect = false);
ALTER SUBSCRIPTION regress_testsub SET (slot_name = '');
SELECT subslotname = '' AS empty FROM pg_subscription;
DROP SUBSCRIPTION regress_testsub;
