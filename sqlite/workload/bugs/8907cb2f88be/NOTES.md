repro.sql builds t4 with an index on (a, +a COLLATE NOCASE), then queries a view whose
aggregate subquery uses `0=NOT+a COLLATE NOCASE IN (SELECT 0)` (the in-23.1 case).
Clean shell prints `1`. Buggy shell aborts with
`Assertion 'ExprUseXList(p)' failed` in sqlite3ExprCollSeq (exit status -6).
