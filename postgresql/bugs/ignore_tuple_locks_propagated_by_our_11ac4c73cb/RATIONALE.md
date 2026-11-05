# Rationale

File: src/backend/access/heap/heapam_visibility.c, function HeapTupleSatisfiesUpdate (xmin is current transaction branch).

The fix.patch added `MultiXactHasRunningRemoteMembers` (multixact.c/.h). Today's code uses `MultiXactIdIsRunning` instead, so only the tqual.c hunks needed reverting.

1. Hunk "HEAP_XMAX_IS_LOCKED_ONLY" in tqual.c: restored the old behaviour, where a locked-only xmax on a tuple created by our own transaction returns TM_Ok. The fix returned TM_BeingModified when other transactions still hold locks (multixact members or a plain locker). With the revert, locks propagated to the new tuple version by our own update are ignored.
2. Hunk "updating subtransaction must have aborted" (multixact xmax with a non-current updater): removed the `MultiXactIdIsRunning` check, so it returns TM_Ok even when other lockers are still running.

The multixact.c and multixact.h additions are not reverted. The helper was already replaced by `MultiXactIdIsRunning` in current code.

Failing oracle case: src/test/isolation||propagate-lock-delete
