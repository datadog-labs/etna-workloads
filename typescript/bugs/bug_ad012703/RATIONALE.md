All changes are in tree/src/services/refactors/moveToFile.ts.

- Imports (findLastIndex, isNamedDeclaration): fix.diff removed these imports; restored because the old code uses them. rangeContainsRange was still imported.
- getRangeToMove (fix hunk @@ -913): today's code already had the fix's expanded-selection logic. Restored the old logic: named-declaration shortcut, early return of the overload range, and returning undefined on partial start/end selections. Without the fix, selections that should expand (expandSelectionRange*) or be rejected (rangeInvalid/rangeSemiValid) behave wrongly.
- getOverloadRangeToMove (fix hunk @@ -1204): restored the old return shape {toMove, afterLast} using findLastIndex, instead of {toMove, start, end}.
- Not reverted: the doChange `program` vs `context.program` hunk (no behavioural difference), and a comment-only change.

Final check.sh: SUMMARY: 11/16 oracle cases failing (11 fix-added).
