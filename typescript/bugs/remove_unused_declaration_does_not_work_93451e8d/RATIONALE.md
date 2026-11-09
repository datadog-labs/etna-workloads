Hunk: removed the early-return in `fixUnusedIdentifier.ts` getCodeActions (`if (isIdentifier(token) && isFunctionDeclaration(token.parent)) return [createDeleteFix(... deleteFunctionLikeDeclaration ...)]`), corresponding to fix.diff hunk 2. Without it, single-fix deletion goes through tryDeleteDeclaration and removes only one overload instead of all declarations of the symbol. The helper and import remain in use by the fix-all path, so the build is fine (fix.diff hunks 1 and 3 are therefore kept).

SUMMARY: 1/1 oracle cases failing (1 fix-added).
