# gh-142830 reintroduced (Modules/_sqlite/connection.c)

The refcounted `callback_context` still exists in v3.15.2. I reverted the
incref/decref pairs in the three connection-level callbacks that the fix's
tests exercise:

- `authorizer_callback`: removed `incref_callback_context(ctx)` and the
  `decref_callback_context(ctx)` before `PyGILState_Release`. This reverses the
  fix hunks for authorizer_callback.
- `progress_callback`: removed the incref and the decref. This reverses the
  matching fix hunks.
- `trace_callback`: removed the incref and the decref at `exit:`. This
  reverses the matching fix hunks.

Without the extra reference, a handler that calls `set_authorizer(None)`,
`set_progress_handler(None, ...)` or `set_trace_callback(None)` frees the
context while the callback is still running. The callback then uses `ctx` after
it has been freed (`ctx->callable`, `print_or_clear_traceback(ctx)`).

The func, step, final, inverse, value and collation callbacks are unchanged.

## Oracle result
`./check.sh` aborts the whole run with a crash (use-after-free). All 32 oracle
cases are reported as failing, because the run is incomplete. The concurrent
mutation tests in AuthorizerTests, ProgressTests and TraceCallbackTests are the
ones that trigger the crash.
