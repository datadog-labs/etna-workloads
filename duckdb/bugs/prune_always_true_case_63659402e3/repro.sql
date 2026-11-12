CREATE TABLE t AS SELECT 'v' || (i // 122880) AS s, i AS p FROM range(491520) r(i);
.mode list
.header off
.once "|grep -o 'Row Groups Scanned: [0-9/ ]*'"
EXPLAIN ANALYZE SELECT sum(p) FROM t WHERE s NOT IN ('v1','v3');
