CREATE TABLE t(a int, b int);
CREATE TABLE s(a int, b int);
INSERT INTO s VALUES (1,1);
EXPLAIN (analyze, timing off, summary off, costs off, buffers off)
MERGE INTO t USING s ON t.a = s.a AND t.a < -1000
WHEN MATCHED THEN DO NOTHING;
