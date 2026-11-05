# Rationale

## src/backend/access/heap/heapam.c, test_lockmode_for_conflict()
Traces to the single hunk in fix_impl.patch (heapam.c, test_lockmode_for_conflict). The fix added
`if (!ISUPDATE_from_mxstatus(status)) return HeapTupleMayBeUpdated;` in the TransactionIdDidCommit
branch (now `return TM_Ok;`). I removed it. A committed *locker* member is then treated like a
committed updater: if lock modes conflict, TM_Updated/TM_Deleted is returned even though the lock
is gone. This causes a spurious abort ("could not serialize" / wrongly reported update) during
update chain locking.

## Failing oracle cases
Failing: `src/test/isolation||multixact-no-forget` (1/1 oracle cases fail with the change).
