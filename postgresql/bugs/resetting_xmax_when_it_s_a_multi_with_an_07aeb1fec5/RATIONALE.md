# Rationale

All changes are in `src/backend/access/heap/heapam_visibility.c`, function `HeapTupleSatisfiesUpdate` (successor of `tqual.c`'s function in fix_impl.patch), in the `HEAP_XMAX_IS_MULTI` branch.

## Hunk 1: the multi with an aborted update
This traces to the single hunk of fix_impl.patch. The fix made the code return the in-progress status (`HeapTupleBeingUpdated`, now `TM_BeingModified`) when the update had aborted but other multixact members were still running. Otherwise it set `HEAP_XMAX_INVALID` and returned OK. I restored the old code: set `HEAP_XMAX_INVALID` only if no member is running, then return `TM_Ok` unconditionally. A running locker is now forgotten.

## Hunk 2: removing the early running check
This is adaptation to the current code. Today's function has an extra `MultiXactIdIsRunning(...) -> TM_BeingModified` check before the `TransactionIdDidCommit(xmax)` test. That check hides the bug, because the buggy tail can only be reached when no member is running. The pre-fix code did not have this check. I removed it so that the reverted tail is reachable again.

## Failing oracle cases
- src/test/isolation||delete-abort-savept

With the bug, `FOR UPDATE` in s2 does not wait for s1's earlier `FOR KEY SHARE` after `ROLLBACK TO` a savepoint that deleted the row.
