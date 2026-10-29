repro.sql creates an fts5 table, then runs SAVEPOINT / INSERT / ROLLBACK TO in autocommit mode.
The first savepoint gives iSavepoint=-1 in xRollbackTo.
Clean shell: no output, exit 0.
Buggy shell: assertion failure `iSavepoint>=0` in fts5CheckTransactionState (abort, exit -6).
