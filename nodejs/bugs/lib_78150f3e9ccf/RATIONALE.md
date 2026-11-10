# Rationale

**Bug:** When a Node Readable is wrapped by `newReadableStreamFromStreamReadable`, cancelling the web stream destroys the Readable; `finished()`'s callback can then fire after the controller was already errored/closed, and it calls `controller.close()` on a stream that does not tolerate it, giving an uncaught `ERR_INVALID_STATE`.

**Change (lib/internal/webstreams/adapters.js):** in the `eos` callback, removed the `if (wasCanceled) { return; }` guard (the current-code equivalent of the fix's added "Was already canceled" early return before `controller.close()`). The `wasCanceled = true` in `cancel()` is kept (it corresponds to the fix's other hunk, which still exists, so the guard is what had to go). Now the callback runs `controller.close()`/`error()` even after cancel.

**Failing tests:** parallel/test-stream-readable-from-web-termination and parallel/test-stream-readable-to-web-termination both report `not ok` (uncaught exception from closing/erroring the controller after cancel), stable across two runs.
