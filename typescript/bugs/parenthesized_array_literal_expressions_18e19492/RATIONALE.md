# Rationale
Single hunk in checker.ts `isSpreadIntoCallOrNew`: the fix introduced `walkUpParenthesizedExpressions(node.parent)` so `...([1,2])` in calls is tupleized. Today's code still has the helper; I reverted it to use `node.parent` directly, so parenthesized array literals spread into calls are no longer tupleized.

Final: SUMMARY: 4/90 oracle cases failing (0 fix-added).
