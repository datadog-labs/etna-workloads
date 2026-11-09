# Rationale
All hunks in `tree/src/compiler/checker.ts` (the fix's other hunks are pure refactors/helpers, with no behaviour change):

1. `checkTestingKnownTruthyCallableOrAwaitableOrEnumMemberType`: reverted `bothHelper`/`helper` to the pre-fix form (fix.diff hunk @@ -39921). No `skipParentheses`, only `||` (not `??`) walks left, `helper` no longer recurses into nested logical right operands.
2. Same function, `testedNode`: restored `isBinaryExpression(location) && isIdentifier(location.right) ? location.right` (fix hunk @@ -39951).
3. `onOperator` in binary-expression checking (fix hunk @@ -35561): the uncalled-function check is again only done for `&&` (not `||`/`??` in an `if`), and the parent walk ignores `??`-style operators.

Result: the uncalled-function check misses/misplaces errors for parenthesized and nested `||`/`??` conditions.
Final: SUMMARY: 2/12 oracle cases failing (0 fix-added).
