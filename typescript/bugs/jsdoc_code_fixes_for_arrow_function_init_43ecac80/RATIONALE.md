# Rationale
File: tree/src/services/codefixes/fixUnmatchedParameter.ts, getRenameAction.
- Signature: removed `jsDocHost` from the destructured Info (fix.diff hunk 1).
- `replaceJSDocComment(sourceFile, jsDocHost, ...)` -> `replaceJSDocComment(sourceFile, signature, ...)` (fix.diff hunk 2). For `const foo = (x) => x`, the signature is the arrow function, not the variable statement hosting the JSDoc, so the existing comment is not replaced and a duplicate is inserted.

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
