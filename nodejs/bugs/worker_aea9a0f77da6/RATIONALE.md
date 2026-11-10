# Re-introduced bug: process._fatalException() returns non-boolean in workers

**Bug:** When a worker's uncaught exception was handled by an `uncaughtException` listener, `workerOnGlobalUncaughtException` (the worker's `process._fatalException`) returned `undefined` instead of `true`.

**Hunk (lib/internal/main/worker_thread.js):** The fix changed `if (!handled) {...}` to an early `if (handled) { return true; }`. The release already has the early-return shape, so I changed `return true;` to `return;`. That restores the pre-fix behaviour, where the handled path falls off the end and returns `undefined`.

**Failing test:** `parallel/test-worker-non-fatal-uncaught-exception` fails in two runs with `actual: undefined, expected: true` (AssertionError from `assert.strictEqual(res, true)`).
