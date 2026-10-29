`repro.sql` creates a table and then runs `CREATE INDEX ... WHERE a=#1` (a syntax error in the partial-index WHERE clause).
Clean shell: reports `near "#1": syntax error`, exit 1.
Buggy shell: the removed `nErr` early-return makes `sqlite3CreateIndex` hit `assert(pParse->nErr==0)`, so it aborts (exit -6).
