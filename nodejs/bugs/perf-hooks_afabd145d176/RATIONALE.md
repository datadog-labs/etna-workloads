# Re-introduced bug: PerformanceObserver gc crash (nodejs/node#39548)

## Bug
After the last 'gc' PerformanceObserver is disconnected, GC tracking is removed but the
"tracking installed" state is not reset. A later 'gc' observer then thinks tracking is still
installed and skips re-registering the V8 GC callbacks; its disconnect (and the env cleanup hook)
removes callbacks that are not registered, corrupting V8's callback vectors and crashing.

## Change (src/node_perf.cc only)
The fix's single hunk adds `gcTrackingInstalled = false;` after `removeGarbageCollectionTracking()`
in lib/internal/perf/observe.js. That JS flag no longer exists; the equivalent state is now
`PerformanceState::gc_tracking_installed` in C++, reset in `GarbageCollectionCleanupHook`.
1. Removed `state->gc_tracking_installed = false;` from `GarbageCollectionCleanupHook` (the
   "reset flag on removal" line, corresponding to the fix's added line).
2. In `ReconcileGarbageCollectionTracking`'s else branch, dropped `env->RemoveCleanupHook(...)`, so the
   cleanup hook stays registered as in the old code (it runs again at exit with the stale flag
   and removes unregistered callbacks). Without this, 2 observe/disconnect cycles did not crash deterministically.

## Failing test
parallel/test-perf-gc-crash: `not ok`, severity crashed, exitcode -6,
`free(): invalid next size (fast)`. Stable across 4 runs.
