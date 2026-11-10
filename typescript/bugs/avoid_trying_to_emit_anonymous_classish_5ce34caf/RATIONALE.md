# Rationale
Hunk changed: `tree/src/compiler/checker.ts`, serializeSymbolWorker variable branch. Removed the
`if (type.symbol && type.symbol !== symbol && ... isFunctionExpressionOrArrowFunction ...)` branch
(fix.diff hunk adding it) so anonymous classish/expando function assignments are again emitted as
`export const x: typeof anonymous` assignments referencing an unreachable type. `else if` became `if`.
The other fix hunks (remappedSymbolReferences plumbing, escapedSymbolName param, trackSymbol check) are
left in place; they become inert without the branch.
Final: SUMMARY: 6/24 oracle cases failing (6 fix-added).
