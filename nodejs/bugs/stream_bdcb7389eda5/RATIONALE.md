# Re-introduced bug: pipeline pump ignores 'close' on the destination (nodejs#39005)

**Bug.** When the destination of a pipeline is closed/destroyed prematurely while the pump waits for
`'drain'` (or for the final write to complete), the pump never wakes up, so the pipeline callback is
never called (no ERR_STREAM_PREMATURE_CLOSE) and the pipeline hangs.

**Change** (lib/internal/streams/pipeline.js, `pumpToNode`, which is today's `pump`).
The fix replaced the one-shot `EE.once(writable,'drain')` waits with a listener set
('drain', 'error', 'close' -> ERR_STREAM_PREMATURE_CLOSE) that wakes the waiter. Today's code
does this through `eos(writable, {readable:false}, resume)`. Hunks:
1. Replaced `eos(...)` with plain `'drain'`, `'error'` and `'finish'` listeners and no `'close'` listener
   (corresponds to the fix's added `.on('close', onClose)` hunk, removed). A premature close no longer resumes the waiter.
2. Matching `off()` calls in `finally` instead of `cleanup()` (corresponds to the fix's `finally` hunk).

**Failing test.** `parallel/test-stream-pipeline`: "not ok", `Mismatched <anonymous> function calls.
Expected exactly 1, actual 0.` at test-stream-pipeline.js:1133, a pipeline callback never called after
the destination was destroyed. Stable over repeated runs. Note: the fix's own new tests
(plain `Stream` emitting 'close') also hang under this change by construction.
