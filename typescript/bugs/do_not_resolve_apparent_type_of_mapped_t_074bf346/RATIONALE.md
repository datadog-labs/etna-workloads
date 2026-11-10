One hunk, src/compiler/checker.ts (~line 17293): `everyType(constraint, isArrayOrTupleType)` -> `everyType(constraint, isArrayType)`.
Corresponds to the single fix.diff hunk, which changed `isArrayType(constraint)` back to `isArrayOrTupleType(constraint)` on the homomorphic type variable's constraint (getConstraintOfTypeParameter). The original function was restructured since, so this is the closest surviving site with the same shape (constraint of the homomorphic type variable checked for array-or-tuple). Reverting to array-only means tuple-constrained mapped types are no longer treated as such, producing the spurious errors in reverseMappedTypeContextualTypesPerElementOfTupleConstraint.ts.
Caveat: the equivalent edits in getResolvedApparentTypeOfMappedType and instantiateMappedType did not fail any test.

SUMMARY: 1/6 oracle cases failing (1 fix-added).
