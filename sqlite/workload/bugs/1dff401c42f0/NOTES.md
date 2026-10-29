Reproducer: `repro.sh` (two shell connections driven through fifos, with sleeps for ordering).
Mirrors fts5misc-16: conn 1 writes to an fts5 table and an attached db inside a transaction;
conn 2 holds a read lock on the attached db, so conn 1's COMMIT fails with "database is locked"
(fts5 is left in eState 2). Conn 1 then runs INSERT into the fts5 table.
Clean: the INSERT succeeds, final output lists abc/def. Buggy: the assert
`pTab->ts.eState==1` in fts5UpdateMethod fails and the shell aborts (SIGABRT).
