CREATE TABLE t1(a INT);
CREATE INDEX i1 ON t1(a,a=a);
INSERT INTO t1 VALUES(1),(2),(3),(4);
SELECT * FROM t1 NATURAL JOIN t1
 WHERE a==1
    OR (
         (SELECT avg(
              (SELECT sum((SELECT 1 FROM t1 NATURAL RIGHT JOIN t1 WHERE a=a)))) AS xyz
         )
         AND a==2
       );
