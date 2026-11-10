# Rationale
One hunk in `tree/src/compiler/checker.ts` (addPropertyToElementList, accessor block).
It corresponds to fix.diff hunk 1 (the added `if (propertySymbol.flags & Accessor)` block that emits separate
get/set declarations when read and write types diverge). Today's code generalised that block; I removed the
`propertyType !== writeType ||` condition so divergent accessors in object literals are emitted as a single
property (using the getter type) again, while the class-only path is untouched.
The other fix hunks (JSDoc refactor, namespace-serialization check) were not needed.

SUMMARY: 9/48 oracle cases failing (4 fix-added).
