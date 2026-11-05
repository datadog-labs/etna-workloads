SET client_min_messages = warning;
CREATE SUBSCRIPTION s CONNECTION 'dbname=doesnotexist' PUBLICATION p1, p2 WITH (connect = false);
ALTER SUBSCRIPTION s DROP PUBLICATION p1 WITH (refresh = false, copy_data = true);
SELECT subpublications FROM pg_subscription WHERE subname = 's';
DROP SUBSCRIPTION s;
