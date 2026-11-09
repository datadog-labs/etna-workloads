# Rationale
Today's code already uses Map-based features, so the fix's data-structure hunk (utilities.ts) is not edited; the bug is re-expressed in checker.ts `getSuggestedLibForNonExistentProperty` (fix hunk 3/"-getOwnKeys ... +allFeatures.get(containingTypeName)"):
- The Map lookup `allFeatures.get(containingTypeName)` is replaced by the pre-fix shape: features regrouped into plain objects keyed by lib target, then indexed by `symbolName(container)` (and `getOwnKeys` import restored, matching the fix's import hunk). A type named `toString` now resolves to the inherited `Object.prototype.toString` function, which is not undefined and is treated as a feature array (`.indexOf` → TypeError crash).
- Lookup of the array uses `indexOf` so inherited function is mishandled (crash in checkPropertyAccessExpression).
Final: SUMMARY: 6/6 oracle cases failing (6 fix-added).
