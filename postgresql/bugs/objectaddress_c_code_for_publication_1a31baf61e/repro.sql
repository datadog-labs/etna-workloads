CREATE SCHEMA s1;
CREATE TABLE s1.t(a int, c int);
CREATE PUBLICATION p FOR TABLE s1.t (a, c);
ALTER TABLE s1.t DROP COLUMN c;
SELECT pg_describe_object(classid,objid,0) FROM pg_depend WHERE classid='pg_publication_rel'::regclass LIMIT 1;
