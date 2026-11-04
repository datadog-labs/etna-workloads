CREATE TABLE t AS VALUES (1, 'foo'), (2, ''), (3, NULL);
SELECT column2 FROM t WHERE column2 !~ '.*' ORDER BY column1;
EXPLAIN SELECT column2 FROM t WHERE column2 !~ '.*';
