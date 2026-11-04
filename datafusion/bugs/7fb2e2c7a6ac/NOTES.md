Reproducer: a parquet file sorted by `a` ('a', 'a0') is registered with declared orderings (a) and (b). The script runs `SELECT concat(a, b) AS c ... ORDER BY c`.

With the bug, `concat` is treated as lex-order preserving, so the sort is dropped. The EXPLAIN shows a bare DataSourceExec, and the result is wrong: `a1, a01`. The clean build keeps the SortExec and returns `a01, a1`.
