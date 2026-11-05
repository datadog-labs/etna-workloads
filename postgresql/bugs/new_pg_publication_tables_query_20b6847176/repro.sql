CREATE TABLE t1(a int, b int, c int);
CREATE PUBLICATION p1 FOR TABLE t1;
SELECT pubname, tablename, attnames FROM pg_publication_tables;
SELECT (pg_get_viewdef('pg_publication_tables'::regclass) LIKE '%attisdropped%') AS filters_dropped;
