# Rationale

**Bug:** pipeTo's batch writer path called `PromisePrototypeThen(writer.writev(...), ...)` directly. A duck-typed writer whose `writev()` completes synchronously and returns `undefined` made `Promise.prototype.then` run on `undefined`, which throws a TypeError after the batch was already accepted.

**Hunk (lib/internal/streams/iter/pull.js, `writeBatch` in pipeTo):** The release has refactored the code (batch entries, `validateBatchEntry`, `entry.byteLength`). The fix's hunk added a `result === undefined` sync-success branch and wrapped the result in `PromiseResolve`. I removed both: the `writevResult === undefined` early return and the `PromiseResolve(...)` wrapper. The code is back to `PromisePrototypeThen(writer.writev(...), ...)`. The `PromiseResolve` import is still used elsewhere in the file, so the import hunk needed no reversal.

**Failing test:** `parallel/test-stream-iter-pipeto-writev` fails (`not ok`) with `TypeError: Method Promise.prototype.then called on incompatible receiver undefined`. It comes from `testWritevSyncUndefinedSuccess`.
