CREATE TABLE t AS VALUES (1, 10.0), (1, 20.0), (2, 30.0);
SELECT column1, sum(sum(column2)) FROM t GROUP BY column1;
SELECT sum(sum(column2)) FROM t;
SELECT column1 FROM t GROUP BY column1 HAVING sum(sum(column2)) > 0;
SELECT sum(column2) FILTER (WHERE sum(column2) > 0) FROM t;
SELECT sum(sum(column2) OVER ()) FROM t;
SELECT sum(sum(column2) OVER ()) OVER () FROM t;
SELECT row_number() OVER (ORDER BY row_number() OVER ()) FROM t;
