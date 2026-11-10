# Re-introduced bug: dgram send with out-of-bounds offset + length

**Bug:** `Socket.prototype.send(buf, offset, length, ...)` did not validate `offset`/`length` against the buffer size. With an out-of-range offset/length, `sliceBuffer` built a `Buffer` view past the end of the underlying data, so garbage memory was sent instead of throwing `ERR_BUFFER_OUT_OF_BOUNDS`.

**Change (lib/dgram.js):**
- Hunk 1 (fix's `sliceBuffer` hunk): removed the `offset > buffer.byteLength` and `offset + length > buffer.byteLength` checks in `sliceBuffer`. This restores the pre-fix behaviour of slicing unchecked.
- Hunk 2 (fix's import hunk): removed the now-unused `ERR_BUFFER_OUT_OF_BOUNDS` import, which the fix had added (avoids a lint error).

**Failing test:** `parallel/test-dgram-send-bad-arguments` fails (stable across 2 runs) with
`AssertionError [ERR_ASSERTION]: Missing expected exception (RangeError).` (expected `"offset" is outside of buffer bounds`).
