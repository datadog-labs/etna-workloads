CREATE SCHEMA s;
SET search_path = s;
CREATE FUNCTION fn(i int) RETURNS int LANGUAGE plpgsql IMMUTABLE AS $$
BEGIN RAISE NOTICE 'sp: %', current_setting('search_path'); RETURN i; END $$;
CREATE TABLE t(i int);
INSERT INTO t VALUES (1);
CREATE INDEX ti ON t (fn(i));
REINDEX INDEX ti;
VACUUM FULL t;
ANALYZE t;
