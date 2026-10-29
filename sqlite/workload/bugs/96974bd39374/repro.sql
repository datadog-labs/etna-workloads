PRAGMA cache_size = 5;
CREATE TABLE t1(a, b);
CREATE INDEX i1 ON t1(a);
WITH cnt(i) AS (
  SELECT 1 UNION ALL SELECT i+1 FROM cnt WHERE i<10000
)
INSERT INTO t1 SELECT i%2, randomblob(500) FROM cnt;
SELECT sum(a), count(*) FROM (SELECT * FROM t1 ORDER BY a, b);
