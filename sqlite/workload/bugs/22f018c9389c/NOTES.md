Reproducer: EXPLAIN QUERY PLAN of `SELECT value FROM generate_series(1,10) ORDER BY value, stop` (tabfunc01-3.12).
Clean: `SCAN generate_series VIRTUAL TABLE INDEX 0x13:` (ORDER BY consumed by generate_series).
Buggy: seriesBestIndex only accepts nOrderBy==1, so the plan uses INDEX 0x3 plus `USE TEMP B-TREE FOR ORDER BY`.
