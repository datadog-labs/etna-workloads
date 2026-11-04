Writes a small CSV, registers it as an unpartitioned external table, and runs
`SELECT c2 FROM t WHERE CASE WHEN true THEN 1/0 ELSE 0 END = 1`.
Clean: the filter is evaluated and fails with "Arrow error: Divide by zero error".
Buggy: the filter is treated as a partition filter for an unpartitioned table and
silently dropped, so both rows (2, 4) are returned and there is no error.
