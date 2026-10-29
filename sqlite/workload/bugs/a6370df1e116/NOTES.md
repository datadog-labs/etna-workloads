Reproducer: repro.sql

1. CREATE TABLE t(a);
2. CREATE TABLE IF NOT EXISTS t(x UNIQUE, y TEXT PRIMARY KEY);

Since t already exists, the IF NOT EXISTS clause means no new table is
parsed, so pParse->pNewTable stays NULL. The UNIQUE and PRIMARY KEY column
constraints still cause sqlite3CreateIndex() to be invoked for the
(nonexistent) new table.

Clean shell: exits 0, prints "done" (the second CREATE TABLE is a no-op as
expected).

Buggy shell: the missing `if( !pTab ) goto exit_create_index;` guard in
sqlite3CreateIndex() lets it dereference the NULL pTab, crashing with
SIGSEGV (exit status -11).
