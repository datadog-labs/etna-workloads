Changed `promoteFromTypeOnly` (src/services/codefixes/importFixes.ts), ImportSpecifier case. The fix added a check that the specifier's index differs from the insertion index before delete+reinsert, otherwise only the `type` keyword is removed. I removed that check, so the specifier is always deleted and reinserted at the insertion index, which corrupts the import when the position is unchanged (the codeFixPromoteTypeOnly1 output shows `TwistyAlgEditorTwistyPlayer, }`).

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
