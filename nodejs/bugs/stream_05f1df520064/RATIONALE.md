# Re-introduced bug: pipeline with destination generator in objectMode

When the last argument of `stream.pipeline` is a function (e.g. an async generator), pipeline wraps its result in a proxy `PassThrough` so it can return a stream. That PassThrough was not in objectMode, so a final generator that yields anything other than strings/Buffers (e.g. objects) caused an `ERR_INVALID_ARG_TYPE` error.

## Change
`lib/internal/streams/pipeline.js` (single hunk): `new PassThrough({ objectMode: true })` became `new PassThrough()`. This corresponds to the fix's only implementation hunk, which added `{ objectMode: true }`. The surrounding code has been reformatted since, but the same spot exists (in the non-stream last-argument branch).

## Failing test
`parallel/test-stream-pipeline` fails (stable across 2 runs):
`AssertionError: ifError got unwanted exception: The "chunk" argument must be of type string or an instance of Buffer, TypedArray, or DataView. Received type number (97)`
