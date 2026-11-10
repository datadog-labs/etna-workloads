# Rationale

**Bug:** `computeNewHighWaterMark` in `lib/internal/streams/readable.js` silently clamped any requested size >= 1GiB to 1GiB. Sizes above the limit (e.g. `readable.read(0x40000000 + 1)`) should throw `ERR_OUT_OF_RANGE` ("size" must be <= 1GiB), but no error was raised.

**Hunks** (all in `lib/internal/streams/readable.js`):
1. Condition `n > MAX_HWM` -> `n >= MAX_HWM` with body `n = MAX_HWM` instead of `throw new ERR_OUT_OF_RANGE(...)`. This reverses the fix's threshold change and its added error (fix hunk 2). The old TODO comment was restored.
2. Removed `ERR_OUT_OF_RANGE` from the `internal/errors` destructuring. This reverses the fix's import hunk, and it is now unused.

**Failing test:** `parallel/test-streams-highwatermark` fails on both runs with
`AssertionError [ERR_ASSERTION]: Missing expected exception.` The test is the `assert.throws(() => readable.read(hwm), ...)` check for `hwm = 0x40000000 + 1`.
