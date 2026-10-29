Reproducer: `repro.sql` (translation of temptable2-7.1). It opens a temp-file database (`.open ""`), enables incremental auto-vacuum, fills a table, then in a transaction deletes rows, runs `PRAGMA incremental_vacuum(4)` and rolls back.

Clean shell: `PRAGMA integrity_check` prints `ok`, exit 0.
Buggy shell: sqlite3PagerMovepage treats only MEMDB (not all temp files) as needing journaling. The rollback corrupts the database, so integrity_check reports "database disk image is malformed" and btreeInitPage errors, exit 1.
