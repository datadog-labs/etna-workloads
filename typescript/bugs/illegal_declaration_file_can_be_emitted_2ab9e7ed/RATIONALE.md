# Rationale
Single hunk in tree/src/compiler/checker.ts, `getUniqAssociatedNamesFromTupleType`: removed the duplicate-name renaming block (the `if (names) {...}` de-dup with `_N` suffixes). This corresponds to the fix.diff hunks that introduced `getUniqAssociatedNamesFromTupleType` and used it in `expandSignatureParametersWithTupleMembers`. Without it, spreading tuples with repeated labels yields duplicate parameter names again (illegal declaration emit).

SUMMARY: 2/6 oracle cases failing (2 fix-added).
