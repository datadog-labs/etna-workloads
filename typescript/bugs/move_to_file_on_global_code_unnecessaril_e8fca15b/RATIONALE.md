# Rationale
Today's `getUsageInfo` (tree/src/services/refactors/moveToFile.ts) no longer has the `!symbol.declarations || isGlobalType(...)` check the fix added; global symbols are instead excluded by the `every(symbol.declarations, decl => isTopLevelDeclaration(decl) && sourceFileOfTopLevelDeclaration(decl) === oldFile)` condition when populating `targetFileImportsFromOldFile` (merged global like `String` has lib declarations, so `every` fails).
Changed hunk: `every` -> `some` in that condition. This corresponds to fix.diff's hunk in getUsageInfo (skipping global types): now a global type merged with a declaration in the old file is treated as a symbol the new file must import from the old file, so unnecessary imports/exports are generated (invalid code).
The `isGlobalType` helper hunk of the fix has no counterpart (nothing uses it).
Result: SUMMARY: 2/3 oracle cases failing (2 fix-added).
