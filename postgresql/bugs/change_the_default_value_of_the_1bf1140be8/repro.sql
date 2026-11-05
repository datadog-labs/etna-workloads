CREATE SUBSCRIPTION regress_sub CONNECTION 'dbname=regress_doesnotexist' PUBLICATION p WITH (connect = false);
SELECT subname, substream FROM pg_subscription;
DROP SUBSCRIPTION regress_sub;
