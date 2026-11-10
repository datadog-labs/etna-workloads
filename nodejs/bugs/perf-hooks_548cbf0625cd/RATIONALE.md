# Re-introduced bug: loop delay resolution validation (548cbf0625cd)

**Bug.** `monitorEventLoopDelay({ resolution })` passes the resolution to native code, which read it as a 32-bit integer. Values that don't fit in int32 (e.g. 2**53) were truncated (2**53 -> 0), so the `CHECK_GT(resolution, 0)` aborted the process instead of a clean `ERR_OUT_OF_RANGE` being thrown.

**Hunks.**
- `src/node_perf.cc` (`CreateELDHistogram`, today's equivalent of `ELDHistogram::New`): `args[0].As<Integer>()` into `int64_t` is changed back to `args[0].As<v8::Int32>()` into `int32_t`. This corresponds to the fix's `node_perf.cc` hunk (the constructor and `node_perf.h` signature hunks have no counterpart: the ELDHistogram class no longer exists and `IntervalHistogram` takes a uint64_t interval).
- `lib/internal/perf/event_loop_delay.js`: `validateInteger(resolution, 'options.resolution', 1)` now has max `Infinity`. The current release rejects 2**53 in JS (default max is MAX_SAFE_INTEGER), so the native truncation would never be reachable. Loosening the JS bound lets the bad value reach the 32-bit native read, as in the old behaviour where it was effectively unchecked.

**Failing test.** `sequential/test-performance-eventloopdelay` fails (`not ok`, exitcode -6, `Assertion failed: (interval) > (0)`) on the `2 ** 53` case. Verified in two runs.
