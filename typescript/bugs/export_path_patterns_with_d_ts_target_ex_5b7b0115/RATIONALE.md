# Rationale
Single hunk in `tree/src/compiler/moduleNameResolver.ts`, `loadEntrypointsFromExportMap`.
The fix wrapped the readDirectory pattern in `isDeclarationFileName(target) ? target.replace("*","**/*") : changeAnyExtension(..., getDeclarationEmitExtensionForPath(target))`.
Today's code uses `changeFullExtension(replaceFirstStar(target,"**/*"), ".*")`, which handles `.d.ts` targets.
I reverted that to the pre-fix behaviour: `changeAnyExtension(replaceFirstStar(target,"**/*"), getDeclarationEmitExtensionForPath(target))`. A `.d.ts` target now yields a `*.d.d.ts` pattern, so no entrypoints are found. The import list was adjusted to match (added `getDeclarationEmitExtensionForPath`, dropped the unused `changeFullExtension`).
Final check.sh: SUMMARY: 2/2 oracle cases failing (2 fix-added).
