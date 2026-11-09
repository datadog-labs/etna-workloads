# Rationale
All hunks in tree/src/services/codefixes/fixAddMissingMember.ts (getInfo), removing `getNonNullableType()` as the fix added:
1. Parameter-type hunk: `checker.getParameterType(signature, argIndex)` no longer non-nullable'd (fix hunk 1).
2. Object-literal/satisfies/return hunk (the `{` branch, restructured since the fix): `targetType` passed without `.getNonNullableType()` (fix hunk 2).
3. Initializer hunk: `targetType` computed without `?.getNonNullableType()` (fix hunk 3).
Effect: nullable contextual types make getUnmatchedProperties find nothing, so the codefix is not offered.

SUMMARY: 4/6 oracle cases failing (4 fix-added).
