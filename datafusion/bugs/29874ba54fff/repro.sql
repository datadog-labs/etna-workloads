CREATE TABLE t AS SELECT arrow_cast(column1, 'Utf8View') AS c FROM (VALUES ('Andrew'), ('Xiangpeng'), ('banana'));
EXPLAIN SELECT c ~ 'an' AS c1 FROM t;
EXPLAIN SELECT c ~* '^a.{3}e' AS c1 FROM t;
EXPLAIN SELECT c !~~ 'xia_g%g' AS c1 FROM t;
SELECT c, c ~ 'an', c ~* '^a.{3}e', c !~ 'an' FROM t ORDER BY c;
