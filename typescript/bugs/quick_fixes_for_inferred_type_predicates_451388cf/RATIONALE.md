# Rationale
One hunk, in `tree/src/services/refactors/inferFunctionReturnType.ts` (`getInfo`). It corresponds to the `inferFunctionReturnType.ts` hunk of fix.diff.
The fix added a branch that gets the signature's type predicate and emits it with `typePredicateToTypePredicateNode`. I removed that branch, so the code only calls `getReturnTypeOfSignature` again. For an inferred predicate the refactor now writes `boolean` instead of `value is string`, which is the original bug.
The checker, types and codefix hunks of the fix are not reverted. They only add the plumbing for predicate nodes, and the codefix path was left alone to keep the change minimal.

Final ./check.sh summary: SUMMARY: 1/2 oracle cases failing (1 fix-added).
