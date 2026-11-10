# Rationale

1. `src/services/completions.ts` (getCompletionEntryCodeActionsAndSourceDisplay): `data?.exportMapKey` -> `undefined`.
   Corresponds to the fix hunk passing `data?.exportMapKey` to `getImportCompletionAction`; without it, details always take the "old way" (search by symbol/module) rather than the exportMapKey lookup.
2. `src/services/codefixes/importFixes.ts` (getAllExportInfoForSymbol): the `info.some(i => i.moduleSymbol === moduleSymbol || i.symbol.parent === moduleSymbol)` filter is removed (keeping the file-exclusion check as `!moduleSymbolExcluded`).
   Corresponds to the fix hunk that added that filter to getAllExportInfoForSymbol; without it, export infos from a different module (e.g. the re-export from an ambient module) can be picked, and completionEntryDetails crashes with a Debug Failure.

Result: `SUMMARY`: 2 fix-added oracle cases (autoImportReExportFromAmbientModule) fail with a Debug Failure in completionEntryDetails.
