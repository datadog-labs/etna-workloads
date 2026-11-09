Hunk: src/services/codefixes/importFixes.ts writeFixes. Corresponds to fix.diff hunk 2 (writeFixes quote preference): the
fix used oldFileQuotePreference when the target has no imports; reverted to always getQuotePreference(sourceFile, preferences),
so moved imports in an import-less target file use the wrong quote style.
(The moveToFile.ts call-site hunk is left alone: the extra argument is harmlessly ignored; signature hunk kept for type-check.)
Final: SUMMARY: 2/3 oracle cases failing (0 fix-added).
