# Rationale

**Bug:** `buf.write(string)` on a buffer shorter than the string threw `ERR_BUFFER_OUT_OF_BOUNDS` ("length" is outside of buffer bounds) instead of silently truncating (e.g. `Buffer.alloc(1).write('ww')` should return 1). Upstream fix dd8eeec3 removed the upper-bound `length > byteLength - offset` check from the `asciiWrite`/`latin1Write`/`utf8Write` wrappers.

**Why not a plain reversal:** In v26.13.0 the wrappers (lib/internal/buffer.js) still carry the upper-bound check, because later upstream changes re-added it. `Buffer.prototype.write` in lib/buffer.js now avoids it by passing an in-range length. So the old defect (a string longer than the buffer ends in the throwing bounds check) is re-created at the call site.

**Change (lib/buffer.js, one hunk plus an import):**
- In `Buffer.prototype.write`, the `buf.write(string)` fast path passed `bufferLength` as the length, so it never exceeded the buffer. It now passes `max(bufferLength, string.length)`. This corresponds to the fix's three hunks, which let over-long writes reach the write helper with an over-long length. With the check in place, the helper throws instead of truncating, as it did before the fix.
- Added `MathMax` to the primordials destructuring, needed by that expression.

**Failing test:** `parallel/test-buffer-write` fails on two consecutive runs with `RangeError [ERR_BUFFER_OUT_OF_BOUNDS]: "length" is outside of buffer bounds`. It comes from `Buffer.alloc(1).write('ww')`. `parallel/test-buffer-alloc` also fails as a side effect, because it relies on truncation.
