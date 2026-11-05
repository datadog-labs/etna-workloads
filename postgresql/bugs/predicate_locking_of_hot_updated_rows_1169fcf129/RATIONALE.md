# Rationale

File: src/backend/access/heap/heapam.c, function heap_hot_search_buffer (single change, traces to the single heapam.c hunks of fix_impl.patch).

Reverted to the pre-fix logic: heapTuple->t_self starts as *tid (the HOT chain root) and only its offset is updated per chain member. The full per-member TID is set only around HeapTupleSatisfiesVisibility/HeapCheckForSerializableConflictOut, then reset to the root *tid. Consequently PredicateLockTID() on a visible tuple uses the root's TID instead of the actual HOT-updated member, so the predicate lock lands on the wrong tuple and SSI misses rw-conflicts on HOT-updated rows.

Failing oracle case: src/test/isolation||predicate-lock-hot-tuple
