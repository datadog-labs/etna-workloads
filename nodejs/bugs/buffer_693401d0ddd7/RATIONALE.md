# Re-introduced bug: lenient buffer range checks (nodejs #27043 / fix 693401d0)

**Bug.** `Buffer#compare` and `Buffer#write` coerced offsets/lengths with `>>> 0` and only partly range-checked them. Overflowing, non-integer or string input was silently wrapped or coerced (e.g. `buf.write('a', 2**32)` wrote at offset 0, `compare(b, '0')` was accepted). The fix replaced this with strict integer validation.

**Hunks (all in lib/buffer.js; today's code uses `validateOffset` where the fix used `validateInt32`).**
- `Buffer.prototype.compare`: `validateOffset(targetStart/sourceStart, ...)` is replaced by the old `if (x < 0) throw ERR_OUT_OF_RANGE; else x >>>= 0`. This matches the fix's compare hunk, reversed. `targetEnd` and `sourceEnd` get the old `> length` check followed by `>>>= 0`.
- `Buffer.prototype.write`: `validateOffset(offset, 'offset', 0, bufferLength)` is replaced by `offset = offset >>> 0`. This matches the fix's write hunk, reversed. Out-of-range or negative offsets now wrap or coerce instead of throwing.
- I did not touch `_fill`, `Buffer.concat` or ERR_NO_LONGER_SUPPORTED. Those hunks do not map cleanly onto the current code.

**Failing tests** (run twice; same result both times):
- test-buffer-alloc: fails.
- test-buffer-compare-offset: fails.
- test-buffer-write: fails. It expects `The value of "offset" is out of range. It must be >= 0 && <= 9. Received -1` and gets `"offset" is outside of buffer bounds`.
- test-buffer-fill: passes.
