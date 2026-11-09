# Rationale
Single file changed: `tree/src/services/stringCompletions.ts`, `getFilenameWithExtensionOption`. It corresponds to the fix's hunks in the same function. The fix added `isExportsWildcard` handling, which today is `isExportsOrImportsWildcard`.
1. Removed the `if (isExportsOrImportsWildcard) { allowedEndings = allowedEndings.filter(...) }` block (`allowedEndings` is now `const`). Minimal and Index endings are no longer dropped for exports wildcards.
2. Removed the `!isExportsOrImportsWildcard &&` guard on the Minimal/Index extension-stripping branch. Wildcard completions now lose their extension, e.g. `card` instead of `card.js`.

Final check.sh summary: SUMMARY: 2/2 oracle cases failing (2 fix-added).
