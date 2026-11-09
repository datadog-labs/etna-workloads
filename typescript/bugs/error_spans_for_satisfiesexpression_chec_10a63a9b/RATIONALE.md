# Rationale
All hunks are in tree/src/compiler/checker.ts; `getEffectiveCheckNode` is kept (still used by checkReturnExpression, matching the fix's helper).
1. Array-literal element iteration (`generateLimitedTupleElements`-style generator): fix yielded `getEffectiveCheckNode(elem)`; now yields raw `elem` again, so errors on `[x satisfies T]` elements span the whole satisfies expression.
2. getSignatureApplicabilityError, per-argument check: reverted to `arg` instead of the effective check node.
3. Same function, single rest argument error node: reverted to `args[argCount]`.
The fix's arrow-body hunk was already refactored into checkReturnExpression (which still uses getEffectiveCheckNode); left untouched.

SUMMARY: 1/6 oracle cases failing (1 fix-added).
