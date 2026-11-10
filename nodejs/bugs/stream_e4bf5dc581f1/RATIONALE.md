# Rationale

**Bug:** `pipeline()` did not finish when a destination stream closed before its source had completed. With `pipeline(remote, local, remote, cb)` the callback never fires with `ERR_STREAM_PREMATURE_CLOSE`, so the pipeline hangs or ends without the error.

**Change (lib/internal/streams/pipeline.js, `pipe()`):**
- Removed the `dst.on('close', ...)` listener, which called `finishOnlyHandleError(new ERR_STREAM_PREMATURE_CLOSE())` if `!ended`. This corresponds to the fix's first hunk, which added the listener. The current code calls `finishOnlyHandleError` where the fix called `finish`.
- Removed the `ended = true` assignment in `endFn`, and the `ended` variable with it. This corresponds to the fix's `src.once('end', ...)` hunk, which added the flag. Today that code is the `endFn` helper.

**Failing test:** `parallel/test-stream-pipeline-duplex` fails (`not ok`, exit code 1) on two consecutive runs. The `common.mustCall` pipeline callback is never invoked, so the test fails.
