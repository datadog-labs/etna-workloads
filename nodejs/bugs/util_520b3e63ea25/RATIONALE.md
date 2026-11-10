# Re-introduced bug: Map/Set entries iterator inspection (upstream 520b3e63ea25)

**Bug.** `util.inspect()` of `Map#entries()` / `Set#entries()` iterators rendered each
`[key, value]` pair as a hand-built string `[ k, v ]` instead of going through the normal
array formatting. Options such as `compact: false` (and line-breaking/width logic) therefore had no effect on the pairs.

**Hunk (lib/internal/util/inspect.js, `formatMapIterInner`, non-weak branch).** Corresponds to the
fix's removal of the `start/end/middle` string building and the new `else` branch calling `reduceToSingleString`.
The current code already had the weak/else split, so I replaced the `else` body (the
`reduceToSingleString(ctx, res, '', ['[', ']'], kArrayExtrasType, recurseTimes)` call) with the old
`` `[ ${key}, ${value} ]` `` string template. The weak branch is unchanged (same as before the fix).

**Failing test.** `parallel/test-util-inspect` (not ok, stable across runs):
```
+ actual - expected
+ '[Set Entries] {\n  [ 1, 1 ]\n}'
- '[Set Entries] {\n  [\n    1,\n    1\n  ]\n}'
```
