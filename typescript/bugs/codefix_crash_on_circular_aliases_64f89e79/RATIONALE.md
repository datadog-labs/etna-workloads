# Rationale
Single file: tree/src/services/exportInfoMap.ts, `forEachNameOfDefaultExport`.
Both fix.diff hunks reverted: removed `const seen = ...` and `if (!addToSeen(seen, current)) break;`.
Without the cycle guard, circular alias chains loop forever / crash (stack/heap exhaustion), as before the fix.
Final: SUMMARY: 2/2 oracle cases failing (2 fix-added).
