repro.sql: creates a table with an index on b and runs EXPLAIN QUERY PLAN on `WHERE b=1 OR b=2 OR b=3`, which the optimizer converts to `b IN (1,2,3)`.
Clean: prints `SEARCH t USING INDEX i (b=?)`, exit 0.
Buggy: the IN term's left side is a bare TK_COLUMN without a table, so sqlite3ExprCollSeq hits `Assertion p->y.pTab!=0` and the shell aborts (exit 134).
