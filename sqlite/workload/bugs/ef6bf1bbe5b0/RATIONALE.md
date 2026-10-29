# Rationale

The fix's fts3 changes were all still present in 3.54.1, so I reversed them directly. The fts5 hunks only removed UNUSED_PARAM lines, so they have nothing to reverse. I left `iSavepoint` in fts3Int.h and the "flush" special-insert command in place. Both are now unused.

- `fts3_write.c` `sqlite3Fts3PendingTermsFlush`: the pending-terms hash is cleared unconditionally again, before the auto-incr-merge step and even if a merge failed (for example on OOM). I removed the `if( rc==SQLITE_OK )` clear at the end. After an OOM the unwritten terms are lost, so a later COMMIT leaves the index corrupt.
- `fts3.c` `fts3SavepointMethod`: back to `rc = fts3SyncMethod(pVtab)` when `bIgnoreSavepoint==0`. This removes the 'flush' special insert and the `iSavepoint` bookkeeping.
- `fts3.c` `fts3ReleaseMethod`: removed `pTab->iSavepoint = iSavepoint`.
- `fts3.c` `fts3RollbackToMethod`: always clears the pending terms, without the `(iSavepoint+1)<=iSavepoint` condition.
- `fts3.c` `fts3RenameMethod`: removed the `bIgnoreSavepoint` set and reset around the ALTER TABLE statements.

## Oracle result
`./check.sh` reports 1 failure: `fts3corrupt4-17.3`. The fix changed this test: after a failed flush, `DROP TABLE` now returns `{0 {}}`. With the bug reintroduced it errors again.
