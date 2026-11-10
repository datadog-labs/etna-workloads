# Bug
Before fix 364c0e196c (perf_hooks webperf idlharness), the IDL interfaces `Performance` and `PerformanceEntry` did not enforce receiver (brand) checks: calling a method/getter with a wrong `this` (null, a prototype object, another object) did not throw TypeError "Illegal invocation" as WebIDL requires. The release has since moved on (the rest of the fix landed, helper renamed `validateThisInternalField`), so only fix item 1 (receiver checks) was re-introduced.

# Hunks
1. lib/internal/perf/performance.js: removed every `validateThisInternalField(this, kPerformanceBrand, 'Performance')` from the Performance methods/getters (clearMarks, clearMeasures, clearResourceTimings, getEntries*, mark, measure, now, setResourceTimingBufferSize, timeOrigin, toJSON) plus the now-unused import. Corresponds to the fix's added `validateInternalField(...)` calls in the Performance class (before the fix there were none, methods were plain functions).
2. lib/internal/perf/performance_entry.js: removed receiver checks from the `name`, `entryType`, `startTime`, `duration` getters of PerformanceEntry. Corresponds to the fix's added `validateInternalField` in those getters.

# Failing tests
wpt/test-hr-time/idlharness.any.{html,worker.html}, wpt/test-performance-timeline/idlharness.any.{html,worker.html}, wpt/test-resource-timing/idlharness.any.{html,worker.html}, wpt/test-user-timing/idlharness.any.{html,worker.html} ("not ok", stable over 2 runs).
Messages: "assert_throws_js: calling operation with this = null didn't throw TypeError", "getting property on prototype object must throw TypeError ... did not throw", "calling getter on wrong object type must throw TypeError ... did not throw".
