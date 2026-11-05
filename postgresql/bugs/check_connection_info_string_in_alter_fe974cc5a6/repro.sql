CREATE SUBSCRIPTION regress_sub CONNECTION 'dbname=regress_doesnotexist' PUBLICATION p WITH (connect = false);
ALTER SUBSCRIPTION regress_sub CONNECTION 'foobar';
SELECT subconninfo FROM pg_subscription WHERE subname = 'regress_sub';
