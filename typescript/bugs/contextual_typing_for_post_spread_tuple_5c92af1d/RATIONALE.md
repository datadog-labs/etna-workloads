# Rationale
Single hunk, `tree/src/compiler/checker.ts`, in `getContextualType` case `ArrayLiteralExpression`.
Corresponds to the fix.diff hunk at `case SyntaxKind.ArrayLiteralExpression` (firstSpreadIndex logic): the fix only passed
an element index when it precedes the first spread. In today's code this is done via `spreadIndices` (first/last) passed to
`getContextualTypeForElementExpression`. The bug is restored by passing only the raw element index, so elements after a spread are
contextually typed by the wrong tuple position.

Final: SUMMARY: 2/12 oracle cases failing (2 fix-added).
