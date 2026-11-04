Reproducer: copies the EXPLAIN and query from the fix's order.slt test (UNION ALL of two constant
projections, CASE over the constant column, ORDER BY a DESC), with target_partitions = 4.

Clean: the plan keeps SortPreservingMergeExec and the result is 0.5, 0.0 (correct DESC order).
Buggy: projecting constants marks them constant across partitions, so the sort is removed
(replaced by CoalescePartitionsExec) and the rows come back as 0.0, 0.5 (wrong order).
