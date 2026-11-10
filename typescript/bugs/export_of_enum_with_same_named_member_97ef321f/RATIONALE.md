# Rationale
One hunk, `tree/src/compiler/utilities.ts` (in `getEnclosingContainer`/`getResolvedName`-style scope walk, ~line 11535). It corresponds to the single hunk of fix.diff (checker.ts, resolveName).
The code has since moved to utilities.ts. The fix changed `isModuleDeclaration(location)` to `isModuleOrEnumDeclaration(location)`, so an enum's name no longer resolves against the enum's own locals. I reverted it to `isModuleDeclaration` and reverted the comment. An enum member with the same name as the enum is now resolved wrongly in the export.

Final: SUMMARY: 2/12 oracle cases failing (2 fix-added).
