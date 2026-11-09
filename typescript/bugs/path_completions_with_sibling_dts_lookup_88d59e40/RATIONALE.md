# Rationale
All changes are in tree/src/services/stringCompletions.ts (getModulesForPathsPattern).
- Removed the `declarationExtension` computation and its entry in `matchingSuffixes` (and the now-unused
  `getDeclarationEmitExtensionForPath` import). Corresponds to the fix.diff hunks adding `declarationExtension`/`matchingSuffixes`
  (the include globs / trimPrefixAndSuffix hunks already consume `matchingSuffixes` in today's code). Without the
  sibling .d.ts suffix, an exports pattern like `./*.js` no longer finds `blah.d.ts`, so completions are wrong (`blah.d` instead of `blah`, or missing).

Final: SUMMARY: 2/3 oracle cases failing (2 fix-added).
