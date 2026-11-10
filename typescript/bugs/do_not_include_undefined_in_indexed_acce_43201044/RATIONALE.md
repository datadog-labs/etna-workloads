Changed one hunk in tree/src/compiler/checker.ts (getIndexedAccessTypeOrUndefined): both occurrences of
`getTotalFixedElementCount(objectType.target)` were replaced by `objectType.target.fixedLength`, which is the
pre-fix code (fix.diff hunk 3). Tuples with trailing fixed elements after a rest/variadic element are then treated as
generic/deferred for indices within the total fixed element count, so the resulting indexed access types differ
(variadicTuples1.types baseline mismatch). Other fix hunks (helper refactors) are left as-is in today's code.

Final: SUMMARY: 1/18 oracle cases failing (0 fix-added).
