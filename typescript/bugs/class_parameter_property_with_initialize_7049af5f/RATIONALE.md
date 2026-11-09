# Rationale
Only hunk changed: `tree/src/compiler/checker.ts`, `isRequiredInitializedParameter` and its call in `requiresAddingImplicitUndefined`.
This matches the fix's checker.ts hunk that added the `enclosingDeclaration` parameter and the
`isFunctionLikeDeclaration(enclosingDeclaration)` branch for parameter properties.
I restored the old behaviour: a parameter with a parameter-property modifier is never "required initialized",
so declaration emit drops the implicit `| undefined` for such a parameter in a constructor type.
The other fix hunks only passed `enclosingDeclaration` through. Today's callers still pass it, and the extra argument is harmless
(`requiresAddingImplicitUndefined` still takes it, but it is now unused).

Final check.sh summary: SUMMARY: 1/6 oracle cases failing (1 fix-added).
