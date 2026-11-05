CREATE TABLE t (c1 int, c2 int);
CREATE INDEX t_i ON t (c1);
REINDEX INDEX CONCURRENTLY t_i;
SELECT pg_describe_object(classid, objid, objsubid) obj, pg_describe_object(refclassid,refobjid,refobjsubid) ref, deptype
FROM pg_depend WHERE classid='pg_class'::regclass AND objid='t_i'::regclass ORDER BY 1,2;
