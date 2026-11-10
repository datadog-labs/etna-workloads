# Bug
`stream.isErrored()` / `stream.isWritable()` did not work for WHATWG `WritableStream`: the class lacked the `kIsErrored`/`kIsWritable` interop getters, so the utilities fell back to Node-stream heuristics and returned wrong results (e.g. `isWritable` null/false for an open stream, `isErrored` false for an errored one).

# Changes (lib/internal/webstreams/writablestream.js)
- Removed the `kIsErrored` and `kIsWritable` imports from `internal/streams/utils` (fix hunk 1, reversed).
- Removed the `get [kIsErrored]()` and `get [kIsWritable]()` getters (fix hunk 2, reversed; adapted since surrounding code has moved, now sits before `[kControllerErrorFunction]`).

# Failing test
parallel/test-whatwg-writablestream: `not ok` with `AssertionError [ERR_ASSERTION]: Expected values to be strictly equal` (isWritable(stream) expected true). Stable over 2 runs.
