.mode list
.nullvalue NULL
SET profiling_renderer_settings = MAP {'operator_casing': 'upper'};
CREATE TABLE t1 AS SELECT i + 100 as x FROM range(250000) AS t(i);
SELECT * FROM t1 where rowid = 6;
EXPLAIN SELECT * FROM t1 where rowid = 6;
SELECT * FROM t1 where rowid = 200000;
EXPLAIN SELECT * FROM t1 where rowid = 200000;
SELECT * FROM t1 where rowid IN (SELECT rowid FROM t1 ORDER BY rowid DESC LIMIT 10) ORDER BY rowid;
SELECT * FROM t1 where rowid IN (6, 9) ORDER BY ALL;
EXPLAIN SELECT * FROM t1 where rowid IN (6, 9);
SELECT * FROM t1 where rowid = 6 OR rowid = 9 ORDER BY ALL;
EXPLAIN SELECT * FROM t1 where rowid = 6 OR rowid = 9 ORDER BY ALL;
CREATE TABLE nested_columns(s STRUCT(a INTEGER, b INTEGER));
INSERT INTO nested_columns VALUES ({'a': 1, 'b': 0}), ({'a': 3, 'b': 2});
EXPLAIN SELECT s.a FROM nested_columns WHERE s.a = 3 AND s.b = 2 AND rowid >= 1;
