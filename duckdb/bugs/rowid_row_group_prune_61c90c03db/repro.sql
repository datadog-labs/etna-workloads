CREATE TABLE t AS SELECT range i FROM range(300000);
.once '|grep -o "Row Groups Scanned: [0-9] / [0-9]"'
EXPLAIN ANALYZE SELECT count(*) FROM t WHERE rowid = 122880;
