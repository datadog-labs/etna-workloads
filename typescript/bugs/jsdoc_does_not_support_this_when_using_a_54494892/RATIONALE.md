# Rationale
Both hunks in `tree/src/compiler/checker.ts` revert the fix:
1. Removed `checkJSDocThisTag` (fix hunk adding the function): it reported `An_arrow_function_cannot_have_a_this_parameter` for `@this` on an arrow function.
2. Removed the `case SyntaxKind.JSDocThisTag` dispatch in `checkSourceElementWorker` (fix hunk adding the case). Without it `@this` tags on arrow functions are never checked.
The import of `JSDocThisTag` is still used elsewhere, so it stays.

Final: SUMMARY: 1/6 oracle cases failing (1 fix-added).
