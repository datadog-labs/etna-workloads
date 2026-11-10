# Re-introduced bug: loose deepEqual Map comparison

**Bug:** In `mapMightHaveLoosePrim` (lib/internal/util/comparisons.js), the final check for loose Map comparison had a logic error. It looked the alternate key up in the wrong map and treated "present with value undefined" as a match, so `new Map([[undefined, true]])` and `new Map([[null, true]])` compare wrongly under loose deepEqual. The same applied to the `[undefined, true]` vs `[true, true]` case.

**Hunk:** the single hunk replaces the last line
`return !b.has(altValue) && innerDeepEqual(item1, item2, kLoose, memo);`
with
`const curB = b.get(altValue); return curB === undefined && b.has(altValue) || innerDeepEqual(item1, curB, kLoose, memo);`.
This corresponds to the fix's one hunk, which replaced the `get`/`has` form with `!a.has(altValue) && innerDeepEqual(item, curB, ...)`. The names are re-expressed for today's code (`a`/`b` swapped, `item1`/`item2`). This is the pre-fix logic.

**Failing test:** `parallel/test-assert-deep` fails (`not ok 1`) with `AssertionError [ERR_ASSERTION]: Expected values to be loosely deep-equal:`. It failed on both runs.
