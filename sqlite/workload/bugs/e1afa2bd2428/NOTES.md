repro.sql builds the seekscan1 table (with ANALYZE) and runs test 1.5:
`SELECT ... WHERE b IN (235,345) AND c<=3 AND a='abc'`.
Clean shell returns no rows. Buggy shell returns `abc|345|7`, because OP_SeekScan
skips the range-end initialization (injection drops `pRangeEnd` from the SeekScan condition),
so the end bound is left at the wrong value.
