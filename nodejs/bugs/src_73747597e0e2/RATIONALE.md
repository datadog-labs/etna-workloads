# Re-introduced bug (CVE-2025-59466, 73747597e0e2)

**Bug:** a stack overflow RangeError thrown inside an async_hooks callback (init/before/after/destroy/promiseResolve) is treated as fatal. The `TryCatchScope` destructor calls `ReportFatalException` and exits with code 7 (kExceptionInFatalExceptionHandler). The exception no longer reaches user `try/catch` or `uncaughtException` handlers.

## Hunks
1. `src/async_wrap.cc` (3 sites: `DestroyAsyncIdsCallback`, `Emit`, `EmitAsyncInit`): `kFatalRethrowStackOverflow` is changed back to `kFatal`. This reverses the fix's three async_wrap hunks.
2. `src/node_errors.cc`, `TryCatchScope::~TryCatchScope`: the condition is back to `mode_ == CatchMode::kFatal`, and the stack-overflow rethrow block is removed. This reverses the destructor hunk.
3. `src/node_errors.cc`, `TriggerUncaughtException`: the mode is back to an unconditional `kFatal`, and the `is_stack_overflow`/`has_js_stack` lambdas are removed. This reverses that hunk.

The enum value `kFatalRethrowStackOverflow` and the `IsStackOverflowError` helper are left in place, so `IsStackOverflowError` is now unused and the compiler warns about it. The build succeeds. The `GetCurrentStackTrace` and `thread_local` hunks of the fix are untouched, since they are not part of this behaviour.

## Failing tests (stable across 2 runs)
- `parallel/test-async-hooks-stack-overflow`
- `parallel/test-async-hooks-stack-overflow-nested-async`
- `parallel/test-async-hooks-stack-overflow-try-catch`

They fail with "Expected exit code 0 ... got 7". The two `test-uncaught-exception-handler-stack-overflow*` tests still pass.
