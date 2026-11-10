# Rationale

**Bug:** The web-streams adapters' `writev` handlers (stream.Writable/Duplex -> WritableStream) passed the
whole `{chunk, encoding}` entry from Node's `writev` array to the WritableStream writer instead of
`entry.chunk`. Batched writes therefore delivered wrapper objects rather than the data.

**Change (lib/internal/webstreams/adapters.js, `dispatchWritev`):** `chunks[i].chunk` -> `chunks[i]`.
Corresponds to the fix's `writer.write(data.chunk)` -> `writer.write(chunk)` hunks (both in
newStreamWritableFromWritableStream and newStreamDuplexFromReadableWritablePair; today both share
`dispatchWritev`, so one edit covers both). The fix's `error.filter` hunks have no counterpart: the
code was rewritten around a write tracker and no longer passes an array of errors to the callback.

**Failing test:** parallel/test-whatwg-webstreams-adapters-to-streamduplex (stable over 2 runs):
`TypeError [ERR_INVALID_ARG_TYPE]: The "chunk" argument must be of type string or an instance of Buffer, TypedArray, or DataView. Received an instance of Object`.
The streamwritable test still passes with this change.
