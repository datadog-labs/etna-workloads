CREATE TABLE t1 AS VALUES (1, 'a'), (2, 'b'), (3, 'c');
CREATE TABLE t2 AS VALUES (1), (1), (2);
SELECT column1, column2 FROM t1
WHERE column1 > 2 OR EXISTS (SELECT 1 FROM t2 WHERE t2.column1 = t1.column1)
ORDER BY column1;
SELECT column1, column2 FROM t1
WHERE column1 > 2 OR column1 IN (SELECT column1 FROM t2)
ORDER BY column1;
