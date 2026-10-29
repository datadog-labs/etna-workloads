.dbconfig defensive off
PRAGMA page_size=1024;
PRAGMA writable_schema=ON;
CREATE VIRTUAL TABLE t1 USING fts5(x);
INSERT INTO t1(t1, rank) VALUES('pgsz', 32);
WITH RECURSIVE c(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM c WHERE i<200)
  INSERT INTO t1(rowid, x)
     SELECT i, CASE WHEN i%10=0 OR i=1 THEN 'a b c x' ELSE 'a b c' END FROM c;
UPDATE t1_data SET block=x'01'||substr(block,2) WHERE id=206158430209;
INSERT INTO t1_data(id, block)
SELECT 206158430209 + i*2147483648, if(i=32,x'000101',x'010101')
  FROM (WITH RECURSIVE r(i) AS (
            SELECT 1 UNION ALL SELECT i+1 FROM r WHERE i<32
          ) SELECT i FROM r);
SELECT rowid FROM t1 WHERE t1 MATCH 'a AND x';
