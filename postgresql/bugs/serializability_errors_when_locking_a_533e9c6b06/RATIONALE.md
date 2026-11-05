# Rationale

Both hunks are in `src/backend/access/heap/heapam.c`, function `heap_lock_tuple`. They trace to the two hunks of fix_impl.patch.

1. The entry condition `else if (result == TM_BeingModified || result == TM_Updated || result == TM_Deleted)` is now `else if (result == TM_BeingModified)`. This reverses the first hunk, which added `HeapTupleUpdated` to the condition. A tuple already updated by a committed transaction no longer enters the wait-analysis branch. It falls through to the generic failure path instead of being handled as a lock-wait case.

2. The `if (require_sleep && (result == TM_Updated || result == TM_Deleted)) { LockBuffer(...); goto failed; } else if (require_sleep)` block is now `if (require_sleep)`. This reverses the second hunk, which made the code skip sleeping when the update had already committed. Without it, a locker facing a committed update could sleep and then hit a serialization error.

Together these bring back the bug where locking a tuple with a committed update raises serializability errors.

Oracle cases that fail: `src/test/isolation||lock-committed-update` and `src/test/isolation||lock-update-delete`. `lock-committed-keyupdate` and `update-locked-tuple` still pass.
