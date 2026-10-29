`repro.sh` starts a background connection that holds a read transaction. A second connection runs `BEGIN; CREATE VIRTUAL TABLE x1 USING fts5(y); COMMIT;`, and the COMMIT fails with "database is locked" because of the reader. It then runs `SAVEPOINT one;` while the fts5 transaction state is above 1.
Clean shell: prints "database is locked" and the script prints `exit=1`.
Buggy shell: the assertion `p->ts.eState==1` fails in fts5CheckTransactionState, so the shell aborts and the script prints `exit=134`.
