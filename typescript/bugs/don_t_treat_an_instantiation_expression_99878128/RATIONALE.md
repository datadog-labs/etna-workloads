# Rationale
Hunk: tree/src/compiler/factory/utilities.ts `isOuterExpression` — corresponds to the fix's utilities.ts hunk.
ExpressionWithTypeArguments is again grouped with TypeAssertionExpression/AsExpression under
`OuterExpressionKinds.TypeAssertions`, so instantiation expressions are skipped as if they were assertions
(the separate ExpressionsWithTypeArguments kind is no longer consulted).
Other fix hunks (enum, ts.ts, nodeFactory) are left as is; they are harmless without this one.

SUMMARY: 1/37 oracle cases failing (1 fix-added).
