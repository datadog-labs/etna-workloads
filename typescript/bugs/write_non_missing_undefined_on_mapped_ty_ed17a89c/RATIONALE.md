# Rationale
Single hunk: in `tree/src/compiler/checker.ts`, the `requiresAddingImplicitUndefined` host method's property case (PropertyDeclaration/PropertySignature/JSDocPropertyTag) now returns `false`.

Corresponds to fix.diff's hunks that add `addUndefined` for optional mapped-type properties whose type contains non-missing `undefined` (the `serializeTypeForDeclaration` hunk / `containsNonMissingUndefinedType` check). In today's code that logic lives in this method. Always returning false means `| undefined` is not written into declaration output for mapped type results, which is the original bug.

Final: SUMMARY: 9/42 oracle cases failing (4 fix-added).
