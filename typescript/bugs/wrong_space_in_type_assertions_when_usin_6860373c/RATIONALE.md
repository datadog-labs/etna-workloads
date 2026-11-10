# Rationale
Single file: tree/src/services/formatting/rules.ts
- Removed `isNonTypeAssertionContext` from the `NoSpaceAfterCloseAngularBracket` rule's context list (fix.diff hunk 1), so the DeleteSpace rule again fires for type assertions followed by `[` / `(`, deleting the space (`<any[]>[]` ignoring insertSpaceAfterTypeAssertion).
- Removed the now-unused `isNonTypeAssertionContext` helper (fix.diff hunk 2; needed to avoid an unused-function build error).

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
