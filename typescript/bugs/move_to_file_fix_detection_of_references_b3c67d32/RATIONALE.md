# Rationale
All changes in tree/src/services/refactors/moveToFile.ts (getUsageInfo area).

1. Re-added `isGlobalType` helper and the `|| isGlobalType(checker, symbol)` early return in the forEachReference callback
   (fix.diff hunks 2 and 3: the fix removed the check and the helper). Symbols whose name matches a global type are skipped,
   so a local type shadowing/merging with a global is not imported into the new file.
2. Replaced `find(symbol.declarations, isInImport)` / `every(...)` logic with the old per-declaration loop
   (fix.diff hunk 2). A merged global+local symbol is treated as importable if any single declaration is top-level in the old file.
   (`every` import is still used elsewhere in the file, so import hunk 1 is not needed.)

Final: SUMMARY: 8/12 oracle cases failing (8 fix-added).
