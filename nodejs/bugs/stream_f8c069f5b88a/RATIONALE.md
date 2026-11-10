# Re-introduced bug: stream MAX_HWM too low (f8c069f5b88a)

**Bug:** `Readable.read(n)` with a large `n` raises the highWaterMark through `computeNewHighWaterMark`. Before the fix the ceiling was 8MB, so `read(10MB)` could never be satisfied. The buffer could not grow to n, so `read(n)` returned null forever and the stream never completed. This breaks the invariant that `read(n)` returns n bytes.

**Change (lib/internal/streams/readable.js, `computeNewHighWaterMark`):** this matches the fix's single implementation hunk, rewritten for today's code.
- `MAX_HWM` goes from `0x40000000` (1GB) back to `0x800000` (8MB).
- The release throws `ERR_OUT_OF_RANGE` for `n > MAX_HWM`. I restored the old behaviour, `if (n >= MAX_HWM) n = MAX_HWM;`, which clamps silently.
- The `ERR_OUT_OF_RANGE` import is now unused in this file. I left it alone.

**Failing test:** `parallel/test-readable-large-hwm` reports `not ok`. It reads 10MB chunks, and the hwm is capped at 8MB, so the stream never reaches 'end'. The run was stable across 2 runs.
