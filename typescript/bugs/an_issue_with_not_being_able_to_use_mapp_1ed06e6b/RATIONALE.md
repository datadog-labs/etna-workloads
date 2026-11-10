# Rationale
Edits in tree/src/compiler/checker.ts (two of the fix's three hunks reverted; third left, as it only affects contextual typing and isn't needed for the bug):
1. Mapped-type instantiation over a homomorphic type variable (~line 17293; fix hunk 1): `everyType(constraint, isArrayOrTupleType)` -> `isArrayType(constraint)`. Union-of-array/tuple constraints are no longer expanded, so a mapped type over a union constraint isn't usable as a rest param.
2. Structured relation (~line 24057; fix hunk 2): restored `isReadonlyArrayType(target) ? isArrayOrTupleType(source) : isArrayType(target) && isTupleType(source) && !source.target.readonly`, so union sources of tuples/arrays are no longer treated as array-like.

Final: SUMMARY: 2/18 oracle cases failing (2 fix-added).
