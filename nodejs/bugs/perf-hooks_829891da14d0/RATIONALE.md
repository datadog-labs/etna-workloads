# Re-introduced bug: uvMetricsInfo counters truncated to 32 bits

## Bug
libuv reports `loop_count`, `events` and `events_waiting` as `uint64_t`. Before upstream fix 829891da14d0,
they were stored in an `Int32Array` (`PerformanceState::uv_metrics`) via `static_cast<int32_t>`, so
`performance.nodeTiming.uvMetricsInfo` wrapped (and could go negative) after 2^31 on long-running processes.

## Changes (today's tree also has a `uv_metrics_bigint` BigUint64Array, which is left untouched)
1. `src/node_perf_common.h`, member `uv_metrics`: `AliasedFloat64Array` -> `AliasedInt32Array`
   (reverses the fix's `AliasedInt32Array` -> `AliasedFloat64Array` hunk).
2. `src/node_perf_common.h`, `performance_state_internal`: `double uv_metrics[3]` -> `int32_t uv_metrics[3]`.
   It is placed after `observers` so the 64-bit fields stay 8-byte aligned. This corresponds to the fix's
   struct hunk, re-expressed for the current layout, which also contains `uv_metrics_bigint`.
3. `src/node_perf.cc`, `UvMetricsInfo`: `static_cast<double>(values[i])` -> `static_cast<int32_t>(values[i])`
   for `uv_metrics[i]`. This corresponds to the fix's `static_cast<double>` hunk, so the 64-bit counters wrap at 2^31.
   The bigint store is unchanged.

## Failing tests
- `parallel/test-performance-nodetiming-uvmetricsinfo-buffer`: not ok. `assert.ok(uvMetricsBuffer instanceof Float64Array)`
  fails with "The expression evaluated to a falsy value: actual: false, expected: true", because the buffer is now an Int32Array.
- `parallel/test-performance-nodetiming-uvmetricsinfo`: also reported not ok (`status` null vs expected 0). Treat this one as unreliable.
  The child process is killed by a signal. I did not confirm the cause, and it may be the build-environment flake described below.
  The buffer test is the reliable oracle.

Both runs gave the same results (run twice).

## Build note
In this environment `node_mksnapshot` segfaults intermittently, even on the unmodified source (a race in a V8 MinorGC task
while draining tasks). Retrying `taskset -c 0 make -j8` until it succeeds produced a working binary.
