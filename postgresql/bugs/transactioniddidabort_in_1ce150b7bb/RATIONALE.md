# Rationale

## src/backend/access/heap/heapam.c, MultiXactIdGetUpdateXid (reached via HeapTupleGetUpdateXid)
Traces to the fix.patch hunk in MultiXactIdGetUpdateXid that removed the
`TransactionIdDidAbort(members[i].xid)` skip (and the "ignore aborted transactions" logic).
The fix made the function return the updater xid regardless of its status, leaving callers to check it.
I re-added the skip, adapted to the current code, which uses `ISUPDATE_from_mxstatus`.
An aborted updater inside a multixact is then ignored, and an update xid can be reported as invalid.
Callers that assume a non-LOCK_ONLY multi has a valid updater then get the wrong answer.
This also relies on clog status in a place that should not use it.

## Failing oracle cases
- src/test/isolation||delete-abort-savept
