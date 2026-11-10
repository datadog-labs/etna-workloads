# Rationale

**Bug:** `AsyncResource.runInAsyncScope` called `emitAfter` only when the callback returned normally. If the callback threw and the exception was caught by user code, the `after` hook was never emitted. The async id stack was left unbalanced, and the process aborted with an async id mismatch.

**Change (lib/async_hooks.js):**
- Hunk 1 corresponds to the fix's `try { ... return ret } finally { if (hasAsyncIdStack()) emitAfter(asyncId) }` hunk. Today's code has `try/finally` with `emitAfter` in the `finally`. I moved `emitAfter` out of the `finally` so it runs only after the callback returns normally. The `finally` now only restores the AsyncContextFrame, which is new code since the fix.
- Hunk 2 corresponds to the fix's `hasAsyncIdStack` import hunk. I removed the import because it is no longer used.

**Failing test:** `parallel/test-async-hooks-run-in-async-scope-caught-exception` gives `not ok` on both runs. The process aborts on the async id stack mismatch. I did not capture the exact message.
