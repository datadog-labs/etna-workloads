# Rationale
One hunk, in `tree/src/compiler/checker.ts`, function `inferTypesFromTemplateLiteralType`. It matches the single hunk of fix.diff.
The fix mapped each placeholder through `isTypeAssignableTo(getBaseConstraintOrType(s), getBaseConstraintOrType(target.types[i])) ? s : getStringLikeTypeForType(s)`.
I reverted that to the pre-fix `map(source.types, getStringLikeTypeForType)`, so placeholders with non-string constraints are always converted to string-like types.
This brings back the wrong inference between placeholders when the source and target texts are equal.

SUMMARY: 1/6 oracle cases failing (1 fix-added).
