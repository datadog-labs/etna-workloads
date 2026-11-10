# Rationale
All hunks are in tree/src/services/refactors/moveToFile.ts. Today's code had refactored the fix (getOverloadRangeToMove returns start/end indices and is also used for the range end), so the fix is re-expressed by removing overload handling.

- Removed the `getOverloadRangeToMove(file, startStatement)` call in `getRangeToMove` (start index), matching fix.diff hunk adding `overloadRangeToMove` in getRangeToMove. `startNodeIndex` made const.
- Removed the `getOverloadRangeToMove(file, statements[endNodeIndex])` call that extended the end index (today's equivalent of the same fix hunk, for the end of the selection).
- Removed the `getOverloadRangeToMove` function (fix.diff hunk adding it at the end of the file), now unused.

Effect: moving a function overload/implementation moves only the selected statement, not all signatures (the original bug).

Summary: SUMMARY: 9/9 oracle cases failing (9 fix-added).
