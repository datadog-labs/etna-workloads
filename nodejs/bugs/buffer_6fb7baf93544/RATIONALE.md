# Re-introduced bug: NaN accepted as Buffer allocation size

Before the fix, the size check was `size < 0 || size > kMaxLength`, which is false for NaN, so
`Buffer.alloc(NaN)`, `allocUnsafe(NaN)`, `allocUnsafeSlow(NaN)` (and `SlowBuffer(NaN)`) silently
returned a zero-length buffer instead of throwing.

## Hunks
- lib/buffer.js, new `assertSize()` helper: corresponds to the fix's `assertSize` hunk
  (`!(size >= 0 && size <= kMaxLength)` -> `size < 0 || size > kMaxLength`). In today's code the
  check is `validateNumber(size,'size',0,kMaxLength)`, which rejects NaN. The helper type-checks
  with `validateNumber(size,'size')` (no range, so NaN passes) and only does the range check when
  the old-style comparison is true; NaN therefore slips through as before.
- lib/buffer.js, `alloc`/`allocUnsafe`/`allocUnsafeSlow`: call `assertSize` instead of validateNumber.
- The fix's `Buffer.concat` hunk is not re-introduced (code rewritten; no such defect remains).

## Failing tests
- parallel/test-buffer-no-negative-allocation (Buffer.alloc(NaN) etc. no longer throw: "Missing expected exception")
- parallel/test-buffer-slow (SlowBuffer(NaN) does not throw)
Both failed on two runs; test-buffer-alloc still passes.
