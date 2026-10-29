repro.sh: connection A switches a db to WAL; connection B holds a read transaction;
A then runs `PRAGMA journal_mode=delete` (fails with "database is locked") and
`PRAGMA journal_mode;` again.
Clean prints `wal` (correct); buggy prints `delete` (walmode-4.10/4.18 failure).
