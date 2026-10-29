repro.sh runs `CREATE TABLE t1(x,UNIQUE(x,x,...))` with 100001 columns in the UNIQUE constraint (createtab-3.1).
Clean shell: "too many columns in index", exit 1. Buggy shell: the early-exit after sqlite3ExprListCheckLength is
removed, so it aborts on assert in sqlite3AllocateIndexObject (nCol <= 2*SQLITE_LIMIT_COLUMN), exit 134.
(createtab-4.x fail only as fallout of the 3.1 abort in the same test run.)
