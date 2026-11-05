# Rationale

File/function: src/backend/access/heap/heapam_visibility.c, HeapTupleSatisfiesVacuumHorizon (HEAP_XMAX_IS_MULTI branch).
Traces to the tqual.c HeapTupleSatisfiesVacuum hunk in fix.patch. The fix lets a committed updater inside a still-running multixact (lockers) be pruned once below the xid horizon (today: `*dead_after = xmax`). The bug is restored by setting dead_after only when the multixact is no longer running; with live lockers the tuple is RECENTLY_DEAD with no horizon, so it is never pruned/frozen away, leaving an updater below the horizon unpruned.

Failing oracle case: src/test/isolation||freeze-the-dead
