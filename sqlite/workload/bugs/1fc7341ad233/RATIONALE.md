# Rationale

Reverses fix 77662cce (sqlite3_deserialize() over a db with an open transaction).

- `src/attach.c` (attachFunc, REOPEN_AS_MEMDB branch): removed the early check that returns
  SQLITE_BUSY when the target Btree has a transaction open or is in a backup. `pNew` is again
  assigned just before the old Btree is closed, with `if( ALWAYS(pNew->pBt) )`, as before the fix.
  The old Btree is therefore closed even while a statement or backup is using it.
- `src/memdb.c` (sqlite3_deserialize): restored `rc = sqlite3_step(pStmt)` with an
  `rc!=SQLITE_DONE` -> SQLITE_ERROR check, and moved `sqlite3_finalize(pStmt)` back to
  `end_deserialize:`. This reverses the second memdb.c hunk. It is needed for equivalence,
  since the new check reports its error through finalize.

## Oracle failures
memdb1-1010 crashes: `sqlite3BtreeClose: Assertion pTmp->pBtree!=p failed`. deserialize is called
inside a running SELECT, and the Btree is closed with an open transaction. The later cases
(1020, backup) are not reached.
