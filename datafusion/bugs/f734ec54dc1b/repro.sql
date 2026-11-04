CREATE TABLE t1(a INT, b INT) AS VALUES
  (NULL, 1), (NULL, 2), (NULL, 3), (NULL, 4), (NULL, 5);
CREATE TABLE t2(c INT) AS VALUES (1), (2);
SELECT sub.a, sub.b FROM (
  SELECT * FROM t1 ORDER BY b LIMIT 1
) sub
JOIN t2 ON sub.a = t2.c;
