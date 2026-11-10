# Rationale
Both hunks in src/compiler/utilitiesPublic.ts correspond to the fix's utilitiesPublic.ts hunks:
- removed `[ScriptTarget.ES2024, "lib.es2024.full.d.ts"]` from `targetToLibMap`
- removed `case ScriptTarget.ES2024:` from `getDefaultLibFileName`
With the target ES2024, the default lib falls through to lib.d.ts instead of lib.es2024.full.d.ts.
Other fix hunks were comment-only and not reintroduced.

Final: SUMMARY: 49/160 oracle cases failing (0 fix-added).
