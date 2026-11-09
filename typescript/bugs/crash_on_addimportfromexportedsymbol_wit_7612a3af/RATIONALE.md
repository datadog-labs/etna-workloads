# Rationale
One hunk in tree/src/services/utilities.ts, `getDefaultLikeExportNameFromDeclaration`: removed the GH#52694 fallback that returns `tryCast(getNameOfDeclaration(d), isIdentifier)?.text` for non-ExportAssignment declarations (the fix's added `: tryCast(getNameOfDeclaration(d), isIdentifier)?.text` branch). Without it, default-exported class/function declarations yield no name, so `addImportFromExportedSymbol` hits its Debug.assert, the original crash.

Summary: 1/1 oracle cases failing (1 fix-added).
