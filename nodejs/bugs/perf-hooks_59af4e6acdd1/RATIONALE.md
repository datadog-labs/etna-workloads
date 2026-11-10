# Rationale

**Bug:** `histogram.percentile(NaN)` was not rejected by the JS argument validation. NaN fails every
comparison (`NaN <= 0`, `NaN > 100`), so it passed the range check and reached the native
`Histogram::Percentile`, which asserts `percentile > 0` and aborts the process. The fix throws a
RangeError for NaN instead.

**Hunk (lib/internal/histogram.js, `Histogram#percentile`):** corresponds to the fix's hunk adding
`NumberIsNaN(percentile) ||` to the range check. I removed `NumberIsNaN(percentile) || ` from that
condition in `percentile()`. The fix's import hunk is not reversed because `NumberIsNaN` is still used
elsewhere in the file. `percentileBigInt`/`percentileCI` did not exist at the time of the fix, so I left
them alone.

**Failing test:** `sequential/test-performance-eventloopdelay` ("not ok"). The process aborts with
`Assertion failed: (percentile) > (0)` at src/histogram-inl.h:136, called from `percentile` in
lib/internal/histogram.js, for the `NaN` case in the invalid-percentile loop.
