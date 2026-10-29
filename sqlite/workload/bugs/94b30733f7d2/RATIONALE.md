# Rationale

Fix (CVS 6837) introduced `btreeEndTransaction()`: when a transaction ends while this
connection still has open cursors, it calls `downgradeAllSharedCacheTableLocks(p)`
and drops to TRANS_READ, rather than relinquishing all shared-cache table locks
(the old `clearAllSharedCacheTableLocks(p)` in CommitPhaseTwo/Rollback).

In 3.54.1 the "other cursors open" branch (`p->inTrans>TRANS_NONE && db->nVdbeRead>1`)
in `btreeEndTransaction()` (src/btree.c) now calls `clearAllSharedCacheTableLocks(p)`
instead of `downgradeAllSharedCacheTableLocks(p)`. This drops the read-locks held by
the still-open cursors, so another connection can take a write-lock on a table
being read. The rest of the branch (inTrans = TRANS_READ) is unchanged. The
prepare.c hunk of the fix is a cosmetic initialisation and was not reverted.

## Oracle
test/sharedlock.test: sharedlock-1.2 (and later cases, as the run aborts) fail;
testfixture hits `Assertion wrFlag==0 || !hasReadConflicts(p, iTable)` in btreeCursor.
