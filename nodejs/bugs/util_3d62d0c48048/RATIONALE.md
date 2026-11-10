# Re-introduced bug: Set#entries() inspection

**Bug.** `util.inspect(new Set([1,2]).entries())` did not treat the iterator as key/value entries; it was formatted like a plain value iterator, so the output was the flat list `{ 1, 1, 2, 2 }` rather than `[ 1, 1 ], [ 2, 2 ]` pairs. Before the fix, Set iterators used a dedicated formatter that called `previewEntries(value)` without the `isKeyValue` flag.

**Hunks.**
1. `lib/internal/util/inspect.js`, `formatRaw`: the `isSetIterator` branch binds `formatSetIterator` instead of `formatIterator`. This matches the fix's `formatter = formatIterator` hunks for Set iterators, which the fix changed from `formatSetIterator`. The code now has one branch, not two, because `getIteratorBraces` replaced the second site.
2. `lib/internal/util/inspect.js`: re-added `formatSetIterator`, which calls `previewEntries(value)` and then `formatSetIterInner(..., kIterator)`. This matches the fix's removal of `formatSetIterator`.
3. `src/node_util.cc`: restored the comment "Fast path for WeakMap, WeakSet and Set iterators." This matches the fix's comment hunk. It has no behavioural effect.

**Failing test.** `parallel/test-util-inspect` fails on both runs:
```
+ '[Set Iterator] {\n  1,\n  1\n}'
- '[Set Entries] {\n  [\n    1,\n    1\n  ]\n}'
at test-util-inspect.js:1408
```
