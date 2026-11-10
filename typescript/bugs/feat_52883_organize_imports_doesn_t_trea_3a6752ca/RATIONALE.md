# Rationale
One hunk, in `tree/src/services/organizeImports.ts` (`organizeImports`): the call
`getTopLevelExportGroups(sourceFile).forEach(g => organizeExportsWorker(g, ...))` is replaced by
`organizeExportsWorker(sourceFile.statements.filter(isExportDeclaration), ...)`.
This corresponds to the fix.diff hunk at `@@ -105,14 +105,14 @@`, which replaced a single flat list of all
top-level exports with groups split by `getTopLevelExportGroups`. Without the grouping, all top-level
exports are merged/sorted together (even across `export ... from` boundaries and blank-line groups), which is the bug.
The other fix hunks (groupByNewlineContiguous rename, etc.) are already harmless refactors in today's code; `getTopLevelExportGroups` is left defined but unused.

Final: SUMMARY: 3/93 oracle cases failing (2 fix-added).
