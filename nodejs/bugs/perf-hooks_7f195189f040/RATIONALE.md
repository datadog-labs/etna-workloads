# Re-introduced bug: GC performance entry startTime not relative to timeOrigin

**Bug:** `PerformanceEntry`s of type `gc` had a `startTime` computed from the raw
monotonic hrtime at GC start (`performance_last_gc_start_mark / 1e6`) instead of
being offset by the process time origin, so `startTime` was huge and inconsistent
with `performance.now()` / `performance.timeOrigin`.

**Change (src/node_perf.cc, `MarkGarbageCollectionEnd`)**
- Corresponds to the fix's first hunk line (`start_time`): removed the
  `- env->time_origin()` subtraction, restoring `start_time = last_gc_start_mark / NANOS_PER_MILLIS`.
- Corresponds to the fix's `duration` line: duration is again `now/1e6 - start_time`
  (the pre-fix form; numerically identical to today's expression since start_time is now the raw value).

**Failing test:** `parallel/test-performance-gc` fails with
`AssertionError: startTime should be relative to performance.timeOrigin.`
(`assert(entry.startTime < 1e4, ...)` at test line 38). Stable across runs.
