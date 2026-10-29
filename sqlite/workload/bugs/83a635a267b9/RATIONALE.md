# Rationale

Fix hunks reversed:

1. `src/vtab.c` `sqlite3VtabSavepoint()`: removed the `sqlite3VtabLock(pVTab)` / `sqlite3VtabUnlock(pVTab)` pair around the xSavepoint/xRelease/xRollbackTo call. This is the fix's second hunk, restored to the pre-fix form. Without the lock, the VTable can be freed if the callback causes it to be disconnected.
2. `ext/fts5/fts5_main.c` `fts5CheckTransactionState()`, case FTS5_ROLLBACKTO: `assert( iSavepoint>=-1 )` changed back to `assert( iSavepoint>=0 )`. This reverses the fix's first hunk. ROLLBACK TO of a savepoint passes iSavepoint==-1 in some cases, so the assert fails.

Oracle: `ext/fts5/test/fts5ai.test` fails. The `fts5ai-full-1.3` case (SAVEPOINT; INSERT; ROLLBACK TO) aborts with `Assertion 'iSavepoint>=0' failed` in fts5CheckTransactionState, and the run ends there, so the other fts5ai cases are incomplete. fts5corrupt3 does not fail (0 of 2016).
