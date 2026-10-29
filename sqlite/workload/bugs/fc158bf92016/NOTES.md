repro.sql: inside a transaction with two open savepoints, runs `INSERT OR ROLLBACK` that hits a
UNIQUE conflict (rolls back the whole transaction), then issues `SAVEPOINT one`.

Clean: the rollback closes the savepoint list; the later statements run normally (prints 1|one).
Buggy: the savepoints are not closed on rollback, so the next statement trips
`Assertion db->pSavepoint==0 || db->autoCommit==0` in sqlite3VdbeExec (abort, exit -6).
