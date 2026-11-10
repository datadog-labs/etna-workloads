# Rationale

**Bug:** When a worker thread's uncaught-exception path fails (unhandled error, or the `uncaughtException` handler itself throws), the worker never set `process.exitCode = 1` / emitted `'exit'` first, so the worker exited with code 0 instead of a non-zero code (issue #37996).

**Change** (lib/internal/main/worker_thread.js, `workerOnGlobalUncaughtException`):
- Removed the `if (!process._exiting) { process._exiting = true; process.exitCode = kGenericUserError; if (!handlerThrew) process.emit('exit', ...) }` block — corresponds to the fix's added block of the same shape (today using `kGenericUserError` instead of `1`). Without it the exit code stays 0.
- Removed the `handlerThrew` variable and its assignment in the catch — corresponds to the fix's `handlerThrew` hunks; now unused.
- Removed the now-unused `kGenericUserError` import (needed only by the removed block).

**Failing test:** `parallel/test-worker-exit-code` — `expected:1 but got:0` (worker throwing in uncaughtException handler / uncaught error cases). `test-process-exit-code` still passes.
