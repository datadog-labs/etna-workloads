CREATE TABLE t4(x, y);
INSERT INTO t4 VALUES(1,'g'),(2,'i'),(3,'l');
WITH aaa(x, y, z) AS (
  SELECT x, y, max(y) OVER xyz FROM t4
  WINDOW xyz AS (ORDER BY x)
)
SELECT *, min(z) OVER (ORDER BY x) FROM aaa ORDER BY 1;
