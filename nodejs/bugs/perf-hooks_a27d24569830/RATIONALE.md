# Re-introduced bug: perf_hooks performance timeline WPT failures (a27d245698)

## Bug
Before the fix, `PerformanceObserver`/`PerformanceObserverEntryList` deviated from the performance-timeline spec:
`getEntriesByName(name, type)` ignored `type`, `observe()` accepted `type` and `entryTypes` together, and the
pending-observer dispatch loop iterated `kPending` while dispatching and cleared it afterwards, so observers re-queued
during a callback were lost (or the set was mutated mid-iteration).

## Changes (all in lib/internal/perf/observe.js)
1. `queuePending` setImmediate callback: reverts to `for (const pending of kPending) pending[kDispatch](); kPending.clear();`
   (fix hunk `@@ -106,9 +107,10`, which snapshots with ArrayFrom and clears before dispatching).
2. `getEntriesByName(name)`: removed the `type` parameter and the type filter
   (fix hunk `@@ -168,8 +170,13`).
3. `observe()`: removed the check that throws when both `entryTypes` and `type` are given
   (fix hunk `@@ -208,6 +215,11`).

The other fix hunks (InvalidModificationError, takeRecords, clearEntriesFromBuffer count, exporting
PerformanceObserverEntryList) were not re-introduced; the release already differs there and they are not needed.

## Failing tests (stable across 2 runs)
- `po-observe-type.any.html`: "Calling observe() with type and entryTypes should throw a TypeError" (assert_throws_js)
- `po-getentries.any.html`: "getEntriesByName with a type with no expected entry expected 0 but got 1"
- `po-callback-mutate.any.html`: hangs (times out) because of the dispatch-loop change.
