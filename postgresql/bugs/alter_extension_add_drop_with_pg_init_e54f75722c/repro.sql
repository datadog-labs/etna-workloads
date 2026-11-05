CREATE TABLE t(a int, b int);
GRANT SELECT ON t TO PUBLIC;
GRANT SELECT(a) ON t TO PUBLIC;
ALTER EXTENSION plpgsql ADD TABLE t;
SELECT objsubid, initprivs FROM pg_init_privs WHERE objoid='t'::regclass ORDER BY 1;
ALTER EXTENSION plpgsql DROP TABLE t;
SELECT count(*) FROM pg_init_privs WHERE objoid='t'::regclass;
