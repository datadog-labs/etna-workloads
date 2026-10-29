# Rationale

Fix hunk reversed: the single `src/whereexpr.c` hunk in `exprAnalyzeOrTerm()` (OR-to-IN conversion).

In `tree/src/whereexpr.c` I restored the pre-fix construction loop:
- Removed the `pCollSeq` tracking and the `sqlite3ExprCompareCollSeq()` mismatch check (and the `pThis` local). The loop again just appends each RHS and sets `pLeft`.
- Removed the `pLeft==0` mismatch branch and the `sqlite3ExprAddCollateString()` step that imposes the common collation on the IN's LHS.
- Restored `assert( pLeft!=0 )` and the unconditional `sqlite3PExpr(TK_IN, dup(pLeft))`.

This is equivalent to the old code: the OR is converted to IN even when the equality terms use conflicting collating sequences, and the IN takes whatever collation its LHS happens to carry.

## Oracle failures (test/where2.test)
where2-6.14.1, 6.14.3, 6.14.4, 6.15.2, 6.15.3, 6.15.4 fail with wrong results, because the mixed-collation ORs are rewritten to `c IN (a,b)` with the wrong collation.
