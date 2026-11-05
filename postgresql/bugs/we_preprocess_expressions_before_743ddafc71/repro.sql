CREATE TABLE t(pk int);
INSERT INTO t VALUES (1);
CREATE SEQUENCE s;
CREATE FUNCTION foolme(int DEFAULT nextval('s')) RETURNS int IMMUTABLE AS 'select $1' LANGUAGE sql;
SET client_min_messages = notice;
ALTER TABLE t ADD COLUMN c3 int DEFAULT foolme();
SELECT attname, atthasmissing FROM pg_attribute WHERE attrelid='t'::regclass AND attnum>0 ORDER BY attnum;
