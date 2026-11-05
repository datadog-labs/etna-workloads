# Rationale

File: src/backend/access/heap/heapam.c, function heap_beginscan().
Traces to the fix.patch hunk in heap_beginscan that changes the predicate-lock condition from `!is_bitmapscan` to `flags & (SO_TYPE_SEQSCAN | SO_TYPE_SAMPLESCAN)` and adds `Assert(snapshot)`.
Reversed: the lock is taken for every non-bitmap scan, which includes ANALYZE scans (SO_TYPE_ANALYZE, NULL snapshot). The Assert was dropped, as it was not in the original code.
ANALYZE therefore takes a relation-level predicate lock with no snapshot, which is the original bug.

Failing oracle case: src/test/regress||vacuum (expected; see oracle output)
