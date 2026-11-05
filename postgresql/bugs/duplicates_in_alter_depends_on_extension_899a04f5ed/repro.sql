CREATE FUNCTION f() RETURNS int LANGUAGE sql AS 'select 1';
ALTER FUNCTION f() DEPENDS ON EXTENSION plpgsql;
ALTER FUNCTION f() DEPENDS ON EXTENSION plpgsql;
SELECT count(*) FROM pg_depend WHERE classid='pg_proc'::regclass AND objid='f'::regproc AND deptype='x';
