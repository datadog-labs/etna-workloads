# Re-introduced bug: pipeline destroys the final readable stream (4d93e105)

**Bug.** `stream.pipeline()` destroyed the last stream even when it was still usable/readable
and had finished without error. That prevents further composition of the final stream
(e.g. an http request or a PassThrough whose readable side is still open).

**Change** (only `lib/internal/streams/pipeline.js`). The code was refactored since the fix:
today `destroyer()` skips streams already marked `finished` (via eos).
The fix's `final` parameter and `err || !final || !readable` guard are expressed there as:
- `destroyer(stream, reading, writing, final)` gains a `final` param, and the call in `pipelineImpl`
  passes `isLastStream`. This corresponds to the fix's new `final` argument to `destroyer`/`wrap`.
- In `destroy`, `if (finished) return;` becomes `if (finished && !final) return;`. This is the removed
  guard (`if (err || !final || !readable)`): the final stream is always destroyed again, even when it
  completed cleanly. For a clean finish with no error it calls `stream.destroy()` directly, so it
  does not surface a spurious AbortError.

**Failing test.** `parallel/test-stream-pipeline` fails (stable across runs) with:
`AssertionError [ERR_ASSERTION]: Expected values to be strictly equal: actual: true, expected: false`
(`dst.destroyed` is true after `pipeline(src, dst)` with a PassThrough destination).
