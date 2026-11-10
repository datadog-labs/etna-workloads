# Re-introduced bug: ReadableStreamBYOBReader error message / inspect

Bug: `new ReadableStreamBYOBReader(stream)` on a non-byte stream threw ERR_INVALID_ARG_VALUE naming the wrong argument (`reader`, value the reader) instead of `stream`; and `ReadableStream` inspect output lacked `supportsBYOB`.

Hunks (both in lib/internal/webstreams/readablestream.js):
1. `setupReadableStreamBYOBReader`: restored `ERR_INVALID_ARG_VALUE('reader', reader, 'must be a byte stream')` (fix changed it to `'stream', stream`).
2. `ReadableStream[kInspect]`: removed the `supportsBYOB` property (fix added it); the surrounding code differs from the fix era (eslint comment) and was removed with it.

Failing test: parallel/test-whatwg-readablestream (stable over 2 runs):
actual: "ReadableStream { locked: false, state: 'readable' }"
expected: "ReadableStream { locked: false, state: 'readable', supportsBYOB: false }"
