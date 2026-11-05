SET enable_seqscan = off;
EXPLAIN (COSTS OFF)
SELECT * FROM pg_class WHERE relname ~ '^pg_class$' COLLATE "POSIX";
EXPLAIN (COSTS OFF)
SELECT * FROM pg_class WHERE relname LIKE 'pg\_class' COLLATE "POSIX";
