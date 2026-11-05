CREATE UNLOGGED TABLE u1 (a int primary key);
CREATE TEMPORARY TABLE t2 (a int primary key);
REINDEX INDEX u1_pkey;
REINDEX INDEX t2_pkey;
SELECT relname, relpersistence FROM pg_class WHERE relname IN ('u1_pkey','t2_pkey') ORDER BY relname;
