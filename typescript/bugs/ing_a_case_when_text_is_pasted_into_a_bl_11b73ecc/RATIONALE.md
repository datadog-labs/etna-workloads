# Rationale
Hunk (tree/src/services/pasteEdits.ts): the `pasteLocations.forEach(... changes.replaceRangeWithText ...)` block was moved from after `runWithTemporaryFileUpdate`/`writeFixes` back to before the `statements` declaration (before import fixes are written). This matches fix.diff's pasteEdits.ts hunks (removal before, re-add after writeFixes). Pasted text edits are recorded before import edits, so in a blank target file the edits are ordered/merged wrongly.
The project.ts hunk of fix.diff is not re-expressed: today's code differs (try/finally, already uses checkDefined) and that part is a refactor/assert cleanup.

Final: SUMMARY: 2/2 oracle cases failing (2 fix-added).
