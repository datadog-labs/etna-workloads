# Rationale
Edits in tree/src/compiler/moduleSpecifiers.ts, `MatchingMode.Pattern` case of tryGetModuleNameFromExportsOrImports:
1. Removed the `canTryTsExtension` branch that tried the raw .ts target against the wildcard pattern first, and dropped `!canTryTsExtension &&` from the plain targetFilePath branch (fix.diff hunks at ~1067-1080). With TS-extension preference, `#src/*` imports no longer get `.ts` specifiers.
2. Declaration-file pattern match returns the substituted specifier without changing to the JS extension (fix.diff hunk at ~1085), restoring `#add.d.ts` style output.

Final: SUMMARY: 3/3 oracle cases failing (3 fix-added).
