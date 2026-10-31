# Rationale

Both hunks are in `Objects/genobject.c` and reverse the corresponding hunks of fix.patch.

- `async_gen_asend_close`: reverted to the pre-fix stub. It sets `ags_state = AWAITABLE_STATE_CLOSED` and returns None. It no longer throws GeneratorExit into the awaitable.
- `async_gen_athrow_close`: reverted the same way, using `agt_state`.

v3.15.2 has the same code in a different form (`_PyAsyncGenASend_CAST` and similar), so the fix's hunks no longer apply textually. The restored stubs are equivalent to what the fix removed.

## Oracle failures
- `AsyncGenTest.test_async_gen_asend_close_runtime_error`: `RuntimeError` not raised.
- `AsyncGenTest.test_async_gen_athrow_close_runtime_error`: `RuntimeError` not raised.
