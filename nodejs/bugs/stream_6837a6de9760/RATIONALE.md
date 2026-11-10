# Re-introduced bug: stream.pipeline rejects an iterable (array) as first argument

**Bug.** `pipeline([1,2,3], transform, cb)` unwrapped `streams[0]` whenever it was an array, regardless of how many arguments were passed. An array used as a source iterable was therefore treated as the list of streams, giving wrong behaviour (e.g. ERR_MISSING_ARGS / invalid stream) instead of piping the iterable.

**Hunk.** `lib/internal/streams/pipeline.js`, `pipelineImpl`: changed `if (streams.length === 1 && ArrayIsArray(streams[0]))` back to `if (ArrayIsArray(streams[0]))`. This corresponds to the fix's single hunk in `pipeline()` (which added the `streams.length === 1` condition); the logic now lives in `pipelineImpl`.

**Failing test.** `parallel/test-stream-pipeline` reports `not ok` (stable across 2 runs), via the new iterable-first-argument cases.
