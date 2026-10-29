repro.sql runs the with5-410 query: a recursive CTE whose recursive step is `t LEFT JOIN c ON t.a = 5`.
Clean shell prints `1`. Buggy shell fails with "Parse error: ON clause references tables to its right" (exit 1),
because the check assumes cursor numbers are allocated in SrcList order, which isn't true for the recursive CTE reference.
