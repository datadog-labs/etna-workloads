# Rationale
One hunk in `tree/src/compiler/checker.ts`, `evaluateEntityNameExpression`: removed the `symbol === getGlobalSymbol(...)` condition from the `isInfinityOrNaNString(identifier.escapedText)` check.
This corresponds to the fix.diff hunk that added the `resolveEntityName(...) === getGlobalSymbol(...)` condition to the Identifier case. Without it, any identifier named `Infinity` or `NaN` evaluates to the numeric value, even when it shadows the global. That is the original bug.

Final check.sh summary: SUMMARY: 1/6 oracle cases failing (1 fix-added).
