Single hunk in tree/src/compiler/checker.ts, getSubstitutionType: re-adds the early return
`|| !isGenericType(baseType) && !isGenericType(constraint)` that fix.diff removed. Non-generic base types
(e.g. interface A in `A extends Record<'foo',string> ? A['foo'] : string`) are no longer wrapped in a substitution
type, so the implied constraint is lost and A['foo'] reports a spurious error (the bug).
Final: SUMMARY: 1/6 oracle cases failing (1 fix-added).
