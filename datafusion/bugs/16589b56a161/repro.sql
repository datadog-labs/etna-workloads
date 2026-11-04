CREATE TABLE t AS VALUES (1, 1), (1, 2), (2, 3), (2, 4), (2, 5);
SELECT NTH_VALUE(column1, NULL) OVER (PARTITION BY column2 ORDER BY column1) AS v FROM t ORDER BY column2;
SELECT column1, NTH_VALUE(column2, 0) OVER (PARTITION BY column1 ORDER BY column2) AS v FROM t ORDER BY column1, column2;
