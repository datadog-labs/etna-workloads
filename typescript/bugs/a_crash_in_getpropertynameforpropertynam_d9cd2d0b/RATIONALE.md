# Rationale
- `tree/src/compiler/utilities.ts` `getPropertyNameForPropertyNameNode`: removed `case SyntaxKind.NoSubstitutionTemplateLiteral:` (fix.diff utilities.ts hunk added it). Without it the switch hits `Debug.assertNever` and crashes.
- `tree/src/compiler/types.ts` `PropertyName`: dropped `NoSubstitutionTemplateLiteral` (fix.diff types.ts hunk added it), required so the build's type-check passes with assertNever.

(The checker.ts hunk was a pure parameter type change; no behaviour, not reproduced.)

Final: SUMMARY: 1/37 oracle cases failing (1 fix-added).
