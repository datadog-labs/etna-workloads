# Re-introduced bug: getEntries*/getEntriesByType not ordered by startTime

The release already stores mark/measure entries in arrays (the linked-list part of the fix is long since gone), so only the second half of the fix ("order entries by startTime when calling getEntriesByType") can be re-introduced. Without it, `performance.getEntries()`, `getEntriesByType()` and `getEntriesByName()` return entries in insertion order rather than startTime order. A measure created later but with an earlier start (e.g. `performance.measure('one','one')` after `measure('three','three')`) is returned in the wrong position.

## Change (lib/internal/perf/observe.js, `filterBufferMapByNameAndType`)
`return ArrayPrototypeSort(bufferList, performanceObserverSorter);` -> `return bufferList;`.
Corresponds to the fix hunk that added the final `ArrayPrototypeSort(bufferList, (first, second) => first.startTime - second.startTime)` to `filterBufferMapByNameAndType`. Removing it restores the pre-fix unsorted result.

## Failing test
`parallel/test-performance-timeline` fails (stable across 2 runs):
actual: [ 'three', 'two', 'one' ], expected: [ 'one', 'two', 'three' ].
