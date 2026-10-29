PRAGMA page_size=4096;
PRAGMA auto_vacuum=FULL;
CREATE TABLE t1(a INTEGER PRIMARY KEY, b ANY);
WITH RECURSIVE c(x) AS (VALUES(1) UNION ALL SELECT x+1 FROM c WHERE x<50)
INSERT INTO t1(a,b) SELECT x, zeroblob(1000) FROM c;
CREATE TABLE t2 AS SELECT * FROM t1;
PRAGMA page_count;
BEGIN;
DROP TABLE t2;
PRAGMA incremental_vacuum=50;
PRAGMA page_count;
PRAGMA max_page_count=2;
ROLLBACK;
PRAGMA page_count;
PRAGMA max_page_count;
