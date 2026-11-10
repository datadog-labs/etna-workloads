# Rationale
One hunk in tree/src/services/refactors/moveToFile.ts, `getExistingLocals`: removed the trailing loop over the moved `statements` that adds symbols referenced by moved code and declared in the target file (corresponds to the fix's last hunk, which added that loop in getExistingLocals/renamed from getExistingImports). Without it, symbols already declared locally in the target file are not treated as existing, so the refactor adds an import of them from the old file (self import).

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
