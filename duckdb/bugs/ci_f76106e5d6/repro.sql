CREATE TABLE t AS SELECT range i FROM range(400000);
SET enable_profiling='json';
SET tracked_metrics=['query.total_row_groups_scanned'];
SELECT count(*) FROM t WHERE __internal_barrier(i = 42);
