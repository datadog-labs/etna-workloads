# Rationale

Hunk: src/backend/access/heap/heapam_handler.c, heapam_tuple_satisfies_snapshot().
Traces to the fix.patch hunk in RI_FKey_check() that added LockBuffer(new_row_buf, SHARE/UNLOCK)
around HeapTupleSatisfiesVisibility(). In current code RI_FKey_check() calls
table_tuple_satisfies_snapshot(), and the buffer locking now lives inside the heap AM callback.
I removed the LockBuffer SHARE/UNLOCK calls there, so visibility is again tested with only a pin
and no content lock (the original bug).

Failing oracle case: src/test/regress||foreign_key
