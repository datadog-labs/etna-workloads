Reproducer (repro.sql): WITHOUT ROWID table t45(a PRIMARY KEY, b, c) with index i45(b);
EXPLAIN QUERY PLAN for `WHERE b=? AND a>?`.
Clean: `SEARCH t45 USING INDEX i45 (b=? AND a>?)` (the trailing PK column in the index is used).
Buggy: `SEARCH t45 USING INDEX i45 (b=?)`; the range constraint on the trailing PK column is not used.
This is the same check as without_rowid1-5.1.
