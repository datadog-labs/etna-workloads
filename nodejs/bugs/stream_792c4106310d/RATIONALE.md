# Rationale

**Bug:** `pipeToSync()` counted a chunk/batch as written (added its bytes to the returned total and kept pulling from the source) even when `writeSync()`/`writevSync()` returned `false` without accepting the data. The result was an inflated byte count and continued writes to a writer that had refused data.

**Change (lib/internal/streams/iter/pull.js, `pipeToSync`)**: the release no longer has `isAcceptedSyncWriteBackpressure`; its equivalent of the fix's hunk is that a `false` result is checked and turned into an `ERR_OUT_OF_RANGE` "budget exhausted" failure. I removed those checks in both the `writevSync` branch and the per-chunk `writeSync` branch, so the return value is ignored and bytes are always added to `totalBytes`, as before the fix. This corresponds to the fix's two `pipeToSync` hunks (writevSync / writeSync result handling). I also removed the now-unused `ERR_OUT_OF_RANGE` import.

**Failing test:** `parallel/test-stream-iter-pipeto-writev` fails (stable over repeated runs) with `AssertionError [ERR_ASSERTION]: Missing expected exception` (expected `{ code: 'ERR_OUT_OF_RANGE' }`, actual undefined).
