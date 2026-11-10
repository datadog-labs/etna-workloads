# Re-introduced bug: source map entries not sorted

**Bug:** `SourceMap` did not sort its mappings after parsing. Since the source map spec allows negative generated-column offsets, mappings can be out of order, and the binary search in `findEntry` then returns wrong entries (#31286).

**Hunk 1** (lib/internal/source_map/source_map.js, `#parseMappingPayload`): the fix added `this.#mappings.sort(compareSourceMapEntry)` after parsing. Today's code uses `ArrayPrototypeSort(this.#mappings, compareSourceMapEntry);`, so I removed that line. This restores the unsorted behaviour. The `compareSourceMapEntry` function is left in place, now unused. The fix's other hunk, which adds that function, is not reverted because it is harmless without a caller.

**Failing test:** `parallel/test-source-map-api` fails with `not ok` on two runs. The new sort-by-negative-offset case makes `findEntry(0, 6).originalColumn` return the wrong value.
