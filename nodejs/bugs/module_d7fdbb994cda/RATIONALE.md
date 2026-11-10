# Rationale

**Bug:** require(esm) converts a rejected evaluation promise into a thrown error, but the V8-created promise is still tracked as a pending unhandled rejection. Even when the user catches the error, the process hits unhandled-rejection handling (a warning, then exit 1 with no listener).

**Hunk:** `src/module_wrap.cc`, in `ThrowIfPromiseRejected`. This is where the fix's `EvaluateSync` hunk lives today. I removed the block that calls `realm->promise_reject_callback()` with `kPromiseHandlerAddedAfterReject`. That block is the fix's added hunk, re-expressed for the current code. Without it the rejected promise is never marked handled, which is the pre-fix behaviour.

**Failing test:** `es-module/test-require-module-error-catching` fails (`not ok`). The error thrown by `require()` is caught by `assert.throws`, but the promise is still reported as an unhandled rejection. The test output shows the uncaught `Error: hello` from `throw new Error('hello')`. It failed in both runs. `test-require-module-synchronous-rejection-handling` still passes.
