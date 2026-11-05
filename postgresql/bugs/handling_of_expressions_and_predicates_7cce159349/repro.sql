CREATE TABLE t (c1 int, c2 text);
CREATE UNIQUE INDEX i1 ON t (c1) WHERE c1::text > ('500000000'::text COLLATE "C");
CREATE UNIQUE INDEX i2 ON t ((1/c1)) WHERE '-H'::text >= (c2::text COLLATE "C");
REINDEX TABLE CONCURRENTLY t;
SELECT pg_get_indexdef('i1'::regclass);
SELECT pg_get_indexdef('i2'::regclass);
