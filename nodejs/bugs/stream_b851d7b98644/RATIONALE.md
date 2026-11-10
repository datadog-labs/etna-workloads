# Rationale

Bug: `finished()`/`eos` decided whether a stream is readable/writable solely from the `stream.readable` / `stream.writable` properties. If user code sets `readable.readable = false` (or `writable.writable = false`) and then destroys the stream, eos treats that side as not a readable/writable at all, so no ERR_STREAM_PREMATURE_CLOSE is reported.

Change (lib/internal/streams/end-of-stream.js, two lines in `eos`): corresponds to the fix's hunk replacing `opts.readable !== false && isReadable(stream)` / `isWritable(stream)` with `stream.readable` / `stream.writable`. Today's code derived these from `isReadableNodeStream(stream)` / `isWritableNodeStream(stream)` (the fix's new helpers' successors); they are now ANDed with `stream.readable` / `stream.writable`, restoring the old property-only check.

Failing: parallel/test-stream-finished — `assert.strictEqual(err.code, 'ERR_STREAM_PREMATURE_CLOSE')` fails (err is undefined/other) in the new writable/readable `= false` + destroy cases.
