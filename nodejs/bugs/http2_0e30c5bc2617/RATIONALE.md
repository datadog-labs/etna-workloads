# Re-introduced bug: no END_STREAM on final non-empty DATA frame (http2)

**Bug.** When an Http2Stream's final chunk is written, the writable side was not shut down
right after that write, so the last DATA frame went out without END_STREAM and a separate
empty DATA frame with END_STREAM was sent later (from `_final`). This costs one extra frame
per stream.

**Hunk (lib/internal/http2/core.js, `[kWriteGeneric]`)** — corresponds to the fix's hunk adding
the `process.nextTick` "shutdown write stream right after last chunk" check and the
`waitingForEndCheck` bookkeeping. Today's code factored this into `endCheckNT`/`finishWrite`
with `state.writePending`; I removed the branch that scheduled `endCheckNT` and set
`state.writePending = 1`, so only the write callback completes the write. `_final` still shuts
down via `shutdownWritable`, restoring the pre-fix behaviour (empty DATA+END_STREAM frame).

The other fix hunks (receive-side `ConsumeHTTP2Data` changes, destroy rstCode change) were not
reproduced: the C++ code was rewritten (ConsumeHTTP2Data now always consumes the whole chunk),
and I kept the change to the single hunk needed.

**Failing tests (stable over 2 runs).**
- `parallel/test-http2-pack-end-stream-flag`: `actual: 5, expected: 4` (framesReceived).
- `parallel/test-http2-padding-aligned`: client write-length list has an extra 16-byte write.
- `test-http2-perf_hooks` and `test-http2-misbehaving-multiplex` still pass.
