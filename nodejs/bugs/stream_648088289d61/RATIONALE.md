# Re-introduced bug: streams in a pipeline do not emit 'error' on abnormal termination

**Bug.** When a pipeline terminates abnormally, the surviving streams were destroyed without the error (`stream.destroy()`). They closed silently and never emitted 'error'. An async iteration over the last stream therefore did not reject with the pipeline error.

**Hunk (lib/internal/streams/pipeline.js, `destroyer().destroy`).** This corresponds to the fix's `return stream.destroy(err)` replacing `return stream.destroy()`. The release now routes through `destroyImpl.destroyer(stream, err)`. I added a branch so that any stream with a `destroy` function is destroyed with no argument, as before the fix. The error is no longer propagated to each stream. The fix's ClientRequest `noop` hunk and the `call`/`destroys` loop hunks have no counterpart in today's code: the release already passes the error to each destroy function, and the `noop` hunk only guarded the new behaviour.

**Failing tests** (both "not ok" in TAP, stable across 2 runs):
- parallel/test-stream-pipeline-async-iterator: `AssertionError: Expected "actual" to be reference-equal to "expected"`. The iteration rejects with `Premature close` (ERR_STREAM_PREMATURE_CLOSE) instead of `kaboom`.
- parallel/test-stream-pipeline: `AssertionError: Expected values to be strictly equal: 'Error' !== 'AbortError'`. The streams are destroyed without the pipeline error.
