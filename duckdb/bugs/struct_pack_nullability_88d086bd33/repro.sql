CREATE TABLE t(i INT);
INSERT INTO t SELECT range FROM range(5000);
EXPLAIN SELECT count(*) FROM t WHERE struct_pack(x := i) IS NULL;
