# Rationale

All changes are in `tree/Objects/genobject.c` and revert fix.patch's implementation hunks one-for-one (the code kept the same structure in v3.15.2; `agt_args` became `agt_typ`).

1. `async_gen_asend_send`: removed `o->ags_state = AWAITABLE_STATE_CLOSED;` in the "already running" branch (hunk 1). A failed asend() stays INIT, so a later send() doesn't raise "cannot reuse already awaited".
2. `async_gen_asend_throw`: removed the `AWAITABLE_STATE_INIT` block (running check, move to ITER, set `ag_running_async = 1`) and the `ag_running_async = 0` on error (hunk 2). throw() on a fresh asend() no longer detects or marks concurrent access.
3. `async_gen_athrow_throw`: removed the same INIT block (with aclose()/athrow() messages) and the three `ag_running_async = 0` resets (hunk 3).

## Oracle failures
Four tests in test_asyncgen fail: `test_async_gen_asend_throw_concurrent_with_send`, `..._with_throw`, and the athrow equivalents. Each fails with "RuntimeError not raised" on `gen2.throw(MyExc)` (expected "asynchronous generator is already running").
