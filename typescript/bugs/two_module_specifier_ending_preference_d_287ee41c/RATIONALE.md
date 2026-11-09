# Rationale
Three hunks reverted (the `extensionsNotSupportingExtensionlessResolution` constant stays, since today's code also uses it in moduleSpecifiers.ts):
1. utilities.ts `usesExtensionsOnImports`: dropped the `!fileExtensionIsOneOf(...)` guard (fix hunk 3), so .mts/.cjs etc. imports count as extension preference.
2. utilities.ts `getModuleSpecifierEndingPreference`: removed the `continue` for non-optional extensions (fix hunk 4).
3. moduleSpecifiers.ts Classic resolution: always `[Index, JsExtension]` ignoring preferredEnding (fix hunk 1).

Final: SUMMARY: 1/2 oracle cases failing (1 fix-added).
