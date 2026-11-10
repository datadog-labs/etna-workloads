# Re-introduced bug: PerformanceObserver 'gc' crash (ea0154814a61)

**Bug:** Registering a second PerformanceObserver for 'gc' installs the GC prologue/epilogue callbacks and the cleanup hook a second time, which crashes the process (here: assertion in `CleanupQueue::Add`, "insertion_info.second == true").

**Change (src/node_perf.cc, `ReconcileGarbageCollectionTracking`):** the early return `if (wanted == state->gc_tracking_installed) return;` became `if (!wanted && !state->gc_tracking_installed) return;`. This corresponds to the fix's hunk in `maybeIncrementObserverCount` (the `gcTrackingInstalled` guard). In the current release the idempotence guard lives in C++ rather than JS, so removing it for the "wanted" case restores the old behaviour: every 'gc' observe call installs tracking again.

**Failing test:** parallel/test-performanceobserver-gc: crashed, exitcode -6, `Assertion failed: (insertion_info.second) == (true)` in `node::CleanupQueue::Add`, from `maybeIncrementObserverCount (observe:177)`. Failed on both runs.
