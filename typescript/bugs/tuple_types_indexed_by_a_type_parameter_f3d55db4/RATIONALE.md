# Rationale
One hunk in `tree/src/compiler/checker.ts` (rest element in binding pattern / getBindingElementTypeFromParentType), matching the single hunk of fix.diff.
The fix computed `baseConstraint` of the parent type (so type-parameter-typed tuples are sliced via their constraint). Today's code does this via mapType over InstantiableNonPrimitive; I removed it and went back to `everyType(parentType, isTupleType)` / `mapType(parentType, ...)`, so a tuple indexed by a type parameter falls back to an array type.

SUMMARY: 2/12 oracle cases failing (1 fix-added).
