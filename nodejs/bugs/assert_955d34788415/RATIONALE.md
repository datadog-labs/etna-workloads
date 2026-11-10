# Re-introduced bug: deep comparison of Sets/Maps with mixed key types

**Bug.** When comparing a Set or Map holding both primitive and object keys, primitive keys were skipped
(treated as matched) in strict mode, and only when `extraChecks` was true. A primitive missing from the other
collection was therefore never reported as a mismatch, so unequal collections compared as equal.
Skipping primitives is only valid when all keys are objects (`extraChecks` false).

**Hunks** (both in `lib/internal/util/comparisons.js`; today's code had been restructured, so these re-express the pre-fix logic):
1. `setObjectEquiv`: corresponds to the fix's first hunk (`else if (b.has(val1)) continue; else if (mode !== kLoose) return false;`).
   Restored the old form: inside `if (extraChecks)`, a primitive/null member does `continue` if `mode !== kLoose || b.has(val1)`,
   so strict mode never returns false for a missing primitive.
2. `mapObjectEquiv`: corresponds to the fix's second hunk. Restored the old combined condition
   `extraChecks && primitive key && (mode !== kLoose || (b.has && innerDeepEqual))` -> `continue`, which skips missing
   primitive keys in strict mode. Also re-added the `extraChecks` const that this function no longer declared.

**Failing test.** `parallel/test-assert-deep` fails ("not ok 1", both runs): the new-style
"Handle sets and maps with mixed keys" case expects `assertNotDeepOrStrict` on the mixed sets/maps to throw,
but they are reported equal.
