Reproducer for the lost OFFSET during LIMIT pushdown (fix #12399).
With target_partitions=4, `GROUP BY ... ORDER BY b DESC OFFSET 1 LIMIT 2` and a
`UNION ALL ... ORDER BY 1 DESC LIMIT 10 OFFSET 4` plan a multi-input
SortPreservingMergeExec. The buggy build drops the GlobalLimitExec carrying the
skip, so the offset is ignored: the first query returns 3 rows instead of 2 and
the second returns 14 rows instead of 10 (clean build is correct).
