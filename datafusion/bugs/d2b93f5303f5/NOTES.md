Reproducer: the second query added to union.slt by the fix (UNION ALL CTE joined with VALUES, filtered by IN, ORDER BY CASE), run with target_partitions=4.

df-clean returns the single row `ns3 4 t3 m`. df-buggy fails the SortPreservingMergeExec sanity check ("does not satisfy order requirements"), because boolean interval AND/OR returns an internal error instead of UNCERTAIN when a bound is NULL.
