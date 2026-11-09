# Rationale
- diagnosticMessages.json: re-added diagnostic 2691 "An import path cannot end with a '{0}' extension..." (fix.diff hunk 2 removed it).
- checker.ts (resolveExternalModule, module-not-found branch): restored `tsExtension = tryExtractTSExtension(...)`, the `if (tsExtension) errorOnTSExtensionImport(...)` branch before the json check, and the `errorOnTSExtensionImport` helper (fix.diff hunks 1 and 3). Importing a .ts path that fails to resolve reports the always-incorrect error again.

Final: SUMMARY: 7/50 oracle cases failing (0 fix-added).
