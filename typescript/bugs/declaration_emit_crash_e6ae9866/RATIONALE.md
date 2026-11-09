# Rationale
Single hunk in tree/src/compiler/checker.ts (getModuleSpecifierOverride, ~line 6426): `isExternalModuleSymbol(parentSymbol)` -> `parentSymbol.flags & SymbolFlags.Module`. Corresponds to the fix.diff checker.ts hunk (and its import hunk, removed here since unused). Namespaces (non-quoted module symbols) are again treated as external modules, so getSpecifierForModuleSymbol hits a Debug Failure (declaration emit crash). The helper already exists in today's code (compiler/utilities.ts) so no utilities hunks were needed.

Final: SUMMARY: 6/6 oracle cases failing (6 fix-added).
