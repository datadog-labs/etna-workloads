# Rationale
Single hunk in `tree/src/compiler/checker.ts` (getWidenedTypeForVariableLikeDeclaration's `isProperty`):
removed `|| isJSDocPropertyTag(declaration)` (and the now-unused import). This corresponds to the fix.diff hunk
at ~line 10164 that added `isJSDocPropertyTag(declaration)` to `isProperty`. Without it, optional JSDoc @property tags
aren't treated as properties, so under exactOptionalPropertyTypes they get `undefined` added (bug 49080).
(The `isOptionalDeclaration` refactor is behaviour-preserving and was left in place.)

SUMMARY: 2/43 oracle cases failing (2 fix-added).
