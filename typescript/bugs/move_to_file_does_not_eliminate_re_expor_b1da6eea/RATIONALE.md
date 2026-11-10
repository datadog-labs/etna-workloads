# Rationale
One hunk, `tree/src/services/refactors/moveToFile.ts` (~line 270): the call to `moveStatementsToTargetFile(...)` in the non-empty target file case is replaced by the original `changes.insertNodesAfter(targetFile, lastStatement, body)`.
This corresponds to the fix.diff hunk in `getNewStatementsAndRemoveFromOldFile` that introduced the call. Without it, re-exports of moved declarations in the target file are never removed or pruned, and the statements are appended after the last statement instead of before the last re-export.
(The helper stays defined but unused; the build still passes.)

Final check.sh: SUMMARY: 5/5 oracle cases failing (5 fix-added).
