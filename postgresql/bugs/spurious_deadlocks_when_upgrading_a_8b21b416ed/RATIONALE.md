# Rationale

Changed hunk: `src/backend/access/heap/heapam.c`, `heap_lock_tuple()`. It traces to the fix.patch hunk
that added `else { ... skip_tuple_lock = true; }` in the loop over the tuple's existing multixact
members. That hunk is removed.

Without it, `skip_tuple_lock` is never set. A transaction that already holds a weaker lock and then
upgrades it therefore still takes the heavyweight tuple lock. That can deadlock with another locker that
holds the tuple lock and waits for our transaction to finish. These deadlocks are spurious.

Only this hunk was reverted. The other fix hunks (the `current_is_member` changes in
`DoesMultiXactIdConflict`, `heap_delete` and `heap_update`) are left in place. This hunk alone is enough
to reproduce the failure.

Failing oracle case: `src/test/isolation||tuplelock-upgrade-no-deadlock`
