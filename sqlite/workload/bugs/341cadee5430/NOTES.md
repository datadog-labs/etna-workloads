Reproducer (`repro.sql`): the savepoint sequence from fts3drop-1.2 — insert into an FTS3 table, DROP TABLE inside a savepoint, then ROLLBACK TO the savepoint, COMMIT, SELECT.

Clean shell: exits 0 and prints the rows `a b c` and `d e f`.
Buggy shell: segfaults (exit status -11), because the savepoint code calls methods on the already-deleted sqlite3_vtab.
