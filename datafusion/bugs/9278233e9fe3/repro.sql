CREATE TABLE t AS VALUES (1),(2),(3);
SELECT count(*) FROM t;
SELECT count() FROM t;
SELECT count(1) FROM t;
SELECT count(*) OVER () FROM t ORDER BY 1;
SELECT * FROM (SELECT count(*) FROM t);
EXPLAIN SELECT count(*) FROM t;
