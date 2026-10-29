# Rationale

Fix (CVS 6440) moved `clearAllSharedCacheTableLocks(p)` inside the
`if( p->inTrans!=TRANS_NONE )` block in CommitPhaseTwo and Rollback, and added
`assert( p->inTrans>0 )`, so BtShared.isPending is not cleared by a handle with
no transaction.

In 3.54.1 both paths share `btreeEndTransaction()` (src/btree.c). Changes:

1. `btreeEndTransaction`: `clearAllSharedCacheTableLocks(p)` is called
   unconditionally, before the `if( p->inTrans!=TRANS_NONE )` check, as before
   the fix (reverses the CommitPhaseTwo and Rollback hunks).
2. `clearAllSharedCacheTableLocks`: removed `assert( p->inTrans>0 )`, which the
   fix added and which would otherwise fire immediately.

Not reverted: the `incrVacuumStep` hunk (`nFin==iLastPg`) and the GetMeta page-1
lock hunk. The incrVacuumStep case is now covered by the `nOrig<nFin ||
nFree>=nOrig` check in sqlite3BtreeIncrVacuum (reverting it changed nothing);
page-1 locking moved out of GetMeta.

## Oracle failure
shared6-3.10: a handle with no open transaction (db3 runs `BEGIN; ROLLBACK`
while db2 holds a read cursor) clears BTS_PENDING early, so db3's
`SELECT * FROM t1` succeeds (`0 {1 2 5 ...}`) instead of
`1 {database table is locked}`.
