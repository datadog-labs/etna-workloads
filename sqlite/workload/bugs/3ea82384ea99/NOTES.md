Reproducer (`repro.sql`): turns off defensive mode, creates a WITHOUT ROWID `sqlite_sequence` table via
writable_schema, inserts rows, then renames table `c1`. The rename updates `sqlite_sequence` through a
nested parse, which reaches the assert removed by the fix (`pParse->nested==0` in sqlite3CompleteInsertion).

Clean shell: prints `a`, `c0`, `c2`, exit 0. Buggy shell: assertion failure, abort (exit -6).
