# Rationale

## src/backend/access/heap/heapam.c, heap_inplace_lock()
Traces to the fix.patch hunk adding heap_inplace_lock(), specifically its TM_BeingModified
branch that, when a non-keyshare, non-self, non-multi xmax is in progress, unlocks the buffer,
runs release_callback, and calls XactLockTableWait() before returning false.
I replaced that final `else` with `ret = true`, so an inplace update no longer waits for a
concurrent uncommitted heap_update() (e.g. GRANT). It proceeds on the old tuple version and the
update is lost once the heap_update commits.

Failing oracle cases:
- src/test/isolation||intra-grant-inplace-db
- src/test/modules/injection_points||inplace
(intra-grant-inplace still passes.)
