# Rationale
Hunk: `tree/src/services/refactors/moveToFile.ts`, `doChange`.
Corresponds to the fix.diff hunk in `doChange` that dropped `|| host.fileExists(targetFile) && program.getSourceFile(targetFile)?.statements.length === 0` from the "new file" condition.
Today's code computes `isForNewFile = !host.fileExists(targetFile)`. I restored the blank-file clause, so an existing empty target is treated as a new file (createNewFile path via a future source file). That brings back the bug: text changes mark an existing file as `isNewFile`, which fails in the server ("Expected isNewFile for (only) new files").
The other fix hunks (insertNodesAtEndOfFile, which today's code still has, and the types.ts parameter rename) are not behavioural and are left unchanged.

Final: SUMMARY: 4/35 oracle cases failing (2 fix-added).
