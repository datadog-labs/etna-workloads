# Rationale

Fix hunk reversed: the `gc: done, ... unreachable, ... uncollectable, ... elapsed` debug output
in `_PyGC_Collect` (Python/gc.c). The fix restored the timing (t1/t2) and the final
`PySys_WriteStderr` under `_PyGC_DEBUG_STATS`. In v3.15.2 the timing is kept in
`stats.ts_start/ts_stop` (still needed for callbacks), so I removed only the
`if (gcstate->debug & _PyGC_DEBUG_STATS) { PySys_WriteStderr("gc: done ...") }` block, which is
the pre-fix behaviour (output lacks elapsed time and unreachable count).

Oracle failure: `test.test_gc.GCTests.test_gc_debug_stats` fails, since stderr no longer
matches `gc: done, .* unreachable, .* uncollectable, .* elapsed`.
