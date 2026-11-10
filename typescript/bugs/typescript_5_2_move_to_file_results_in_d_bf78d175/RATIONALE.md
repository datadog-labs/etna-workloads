Single hunk, src/services/refactors/moveToFile.ts, getUsageInfo: removed the
`if (existingTargetLocals.has(skipAlias(symbol, checker))) { unusedImportsFromOldFile.add(symbol); return; }`
check. This corresponds to the fix.diff hunk adding `existingTargetImports.has(...)` (today renamed existingTargetLocals).
Without it, symbols already imported in the target file are re-imported, producing duplicate imports (e.g. `const { x, x } = require("./common")`).
The other fix hunks (getExistingImports, doChange wiring) are now getExistingLocals and still exist but are inert.

Final: SUMMARY: 4/4 oracle cases failing (4 fix-added).
