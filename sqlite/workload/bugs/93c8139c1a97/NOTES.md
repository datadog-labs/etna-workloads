repro.sql: creates a view v2 whose nested WITH clauses reference the view itself (with2-11.1/11.2 from the fix), then renames a column of t1 and selects from v2.
Clean shell: prints `CREATE TABLE t1(b)` and `55`, exit 0.
Buggy shell: assertion failure `pParse->pWith!=pWith` in sqlite3WithPush (exit 134), because the injection removes the `pParse->nErr` guards.
