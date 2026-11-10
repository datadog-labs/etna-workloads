# Rationale

**Bug:** `readable.unshift(<string>)` did not convert the string to a Buffer and ignored the `encoding` argument, so the string was stored raw in the buffer (wrong type/encoding; could cause "Argument must be a buffer" errors).

**Change:** in `lib/internal/streams/readable.js`, `readableAddChunkUnshiftByteMode`, the string branch (which applied `encoding || defaultEncoding`, and converted via `Buffer.from(chunk, encoding)` or `.toString(state.encoding)`) is replaced by a no-op. This corresponds to the fix's hunk adding the `addToFront` string-conversion logic in `readableAddChunk` and the `encoding` parameter to `unshift`; removing it restores the pre-fix behaviour where unshifted strings are stored unconverted.

**Failing test:** `parallel/test-stream-readable-unshift` fails (not ok) with `AssertionError: The expression evaluated to a falsy value` (`assert(Buffer.isBuffer(chunk))` — chunk is a string). Failure was stable across two runs.
