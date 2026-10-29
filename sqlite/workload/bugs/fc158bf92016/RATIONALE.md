# Rationale

Fix (CVS 6128) added `sqlite3CloseSavepoints(db)` after `sqlite3RollbackAll(db)`
in two places in `sqlite3VdbeHalt()` (src/vdbeaux.c). Both are removed again:

1. The forced-rollback branch for special errors (IO error, etc.), the
   hunk at old line ~1583. In 3.54.1 this is the `else` branch after the
   `SQLITE_NOMEM/SQLITE_FULL` check, right after `sqlite3RollbackAll(db, SQLITE_ABORT_ROLLBACK)`.
2. The `else` (OE_Rollback) branch of the `eStatementOp==0` block, the
   hunk at old line ~1628. It is the same call pair in the current code.

The third `sqlite3CloseSavepoints` call, after `sqlite3VdbeCloseStatement` fails,
is not part of this fix and is left alone.

With both calls gone, a rollback with open savepoints sets autoCommit=1 but leaves
`db->pSavepoint` set.

## Oracle failures
savepoint-12.4 (`SAVEPOINT one` after the `INSERT OR ROLLBACK` constraint failure with
open savepoints) hits `Assertion db->pSavepoint==0 || db->autoCommit==0` in
sqlite3VdbeExec, so the testfixture aborts. Later cases in the file do not run.
