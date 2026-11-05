CREATE FUNCTION fn(i int) RETURNS int LANGUAGE plpgsql AS $$
BEGIN RAISE NOTICE 'sp: %', current_setting('search_path'); RETURN i; END $$;
CREATE TABLE t(i int);
INSERT INTO t VALUES (1);
SET search_path = public;
CREATE MATERIALIZED VIEW mv AS SELECT fn(i) FROM t;
