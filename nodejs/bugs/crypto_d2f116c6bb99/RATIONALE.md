# Re-introduced bug: randomFill default size uses byte length

**Bug:** `crypto.randomFill(buf, [offset,] callback)` computed the default `size` as a byte count, but `assertSize()` multiplies size by the element size again. For multi-byte typed arrays (Uint16Array, Uint32Array) the size is therefore too large and it throws `ERR_OUT_OF_RANGE` ("size + offset") instead of filling the buffer.

**Changes (lib/internal/crypto/random.js, `randomFill`):**
- Hunk 1 (fix: `size = buf.length` when offset is the callback): now `size = getByteLength(buf)`. This corresponds to the old `buf.byteLength` and removes the "size is a length" handling.
- Hunk 2 (fix: `size = buf.length - offset` when size is the callback): now `size = getByteLength(buf) - offset`, the old byte-based form.
- The fix's removal of the TODO comment has no behavioural effect and was not reproduced.

**Failing test:** `parallel/test-crypto-random` fails with
`RangeError [ERR_OUT_OF_RANGE]: The value of "size + offset" is out of range. It must be <= 20. Received 40`
(from `crypto.randomFill(new Uint16Array(10), 0, cb)`). The failure was stable across two runs.
