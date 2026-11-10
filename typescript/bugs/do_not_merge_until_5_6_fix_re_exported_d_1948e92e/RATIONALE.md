# Rationale
- services/exportInfoMap.ts: restores `forEachNameOfDefaultExport(defaultExport, checker, compilerOptions, preferCapitalizedNames, cb(name))` (single name, one capitalization chosen by caller), removes the local checker-based `getNamesForExportedSymbol`, and calls the utilities version without the checker (fix hunks 2-6 of exportInfoMap.ts). Re-exported defaults are no longer resolved through the alias chain when building the map.
- services/codefixes/importFixes.ts: two call sites go back to the old signature (fix's two importFixes hunks).
- services/utilities.ts: restores `getNamesForExportedSymbol` and `needsNameFromDeclaration` (non-Transient check) used by getNameForExportedSymbol (fix's utilities hunks).

Final check.sh: SUMMARY: 1/1 oracle cases failing (1 fix-added).
