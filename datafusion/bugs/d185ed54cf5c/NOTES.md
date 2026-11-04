repro.sql: COPY of a UNION ALL of two constant-projection branches (`2 AS a`, `1 AS a`) with ORDER BY a, b
to a parquet file, then reads the file back without ORDER BY.

Clean: the SortPreservingMergeExec under DataSinkExec keeps `a, b`; the file rows are (1,10),(1,20),(2,10),(2,20).
Buggy: the heterogeneous-constant `a` is pruned from the sort, so the merge is only `b`; the file rows are
(2,10),(1,10),(2,20),(1,20), which is not in global order. The EXPLAIN plan differs as well.
