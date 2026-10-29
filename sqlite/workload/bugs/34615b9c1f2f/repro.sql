CREATE TABLE t3(id INT);
INSERT INTO t3 VALUES (0), (3), (0), (5);
SELECT t3.id, x.c0
  FROM t3 LEFT JOIN (SELECT 1 AS c0 FROM (VALUES(0),(4))) AS x
         ON t3.id>=1;
