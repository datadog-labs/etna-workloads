# Rationale

Only `src/src/backend/access/heap/heapam.c`, function `heap_lock_tuple`, was changed. This reverts the `heap_lock_tuple` hunks of fix_impl.patch.

1. The `skip_tuple_lock` variable is removed. This is the hunk `bool skip_tuple_lock = false;`.
2. The `else { skip_tuple_lock = true; }` branch is removed. That branch is where a weaker lock gets promoted while we are already a multixact member.
3. The `heap_acquire_tuplock` call is made unconditional again. It was `if (!skip_tuple_lock && !heap_acquire_tuplock(...))`.

With these changes, a transaction that upgrades a tuple lock it already holds takes the heavyweight tuple lock again. It can then deadlock with another locker that holds that lock and is waiting for our transaction to finish.

I did not revert the `DoesMultiXactIdConflict` / `current_is_member` hunks in `heap_delete` and `heap_update`. The `heap_lock_tuple` change alone is enough to bring the bug back.

Failing oracle case: `src/test/isolation||tuplelock-upgrade-no-deadlock`.
