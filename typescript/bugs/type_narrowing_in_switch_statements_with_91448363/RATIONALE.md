# Rationale
Hunk: `getTypeAtSwitchClause` in tree/src/compiler/checker.ts: removed `skipParentheses(...)` around `flow.node.switchStatement.expression`. Corresponds to the single hunk of fix.diff (today's code reads `flow.node.switchStatement`). Without it, `switch ((x))` isn't matched as a reference, so narrowing fails.

Final check.sh: SUMMARY: 2/6 oracle cases failing (2 fix-added).
