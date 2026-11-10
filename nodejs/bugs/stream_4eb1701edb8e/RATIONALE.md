# Rationale

**Bug:** `finished()`/eos assumed a Duplex would emit 'close' (willEmitClose) even when the user explicitly disabled
the readable or writable side via options (e.g. `{readable: true, writable: false}`), so the callback was
never invoked for a read-only Duplex whose writable side never finishes.

**Change** (lib/internal/streams/end-of-stream.js, one hunk): corresponds to the fix's hunk adding
`isReadable(stream) === readable && isWritable(stream) === writable` to the willEmitClose condition. In the
current code that condition is expressed as `isReadableNodeStream(stream) === readable && isWritableNodeStream(stream) === writable`
combined with `_willEmitClose(stream)`; I removed those two comparisons so `willEmitClose = _willEmitClose(stream)`,
restoring the old behaviour of trusting 'close' regardless of the requested sides.

**Failing test:** parallel/test-stream-finished: `Mismatched noop function calls. Expected exactly 1, actual 0.`
(test-stream-finished.js:458, the read-only Duplex `finished` callback never fires).
