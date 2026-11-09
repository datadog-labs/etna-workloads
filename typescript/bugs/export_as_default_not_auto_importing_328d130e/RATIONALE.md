# Rationale
Hunk: tree/src/services/utilities.ts, `getDefaultLikeExportNameFromDeclaration` — removed the
`isExportSpecifier(d) && d.symbol.flags === SymbolFlags.Alias` branch returning `d.propertyName` text.
This corresponds to the fix.diff hunk that added that branch. Without it, `export { foo as default }`
is named "default"/the filename-derived name instead of `foo`, so auto-import completions for `foo` are not found.

Final check.sh: SUMMARY: 1/2 oracle cases failing (1 fix-added).
