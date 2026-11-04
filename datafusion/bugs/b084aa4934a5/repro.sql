CREATE TABLE t AS SELECT * FROM (VALUES ('a',2),('b',3),('c',1),('d',4)) AS x(k,v);
EXPLAIN SELECT string_agg(k, ',' ORDER BY v ASC), string_agg(k, ',' ORDER BY v DESC) FROM t;
SELECT string_agg(k, ',' ORDER BY v ASC), string_agg(k, ',' ORDER BY v DESC) FROM t;
