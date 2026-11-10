# Rationale
One hunk, in `src/compiler/checker.ts` `resolveExternalModule` (contextSpecifier computation), matching the single hunk of fix.diff.
The fix replaced the exact-node check `isInJSFile(location) && isJSDocImportTag(location)` with `findAncestor(location, or(isImportDeclaration, isJSDocImportTag, isExportDeclaration))`. I restored the pre-fix form: the JSDoc `@import` tag is only recognised when `location` is the tag itself, not a descendant (e.g. the specifier string). The resolution mode is therefore not derived from the specifier, so `--moduleResolution bundler` resolution for JSDoc `@import` is wrong, and importTag21 "Correct errors" fails.
Final check.sh summary: SUMMARY: 1/12 oracle cases failing (1 fix-added).
