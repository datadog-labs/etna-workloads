# Rationale

Fix hunk (src/where.c): `whereRightSubexprIsColumn()` gained `!ExprHasProperty(p, EP_FixedCol)`, so a right-hand column made fixed by constant propagation is not treated as an equivalence-class member.

## Changes
1. `src/where.c` `whereRightSubexprIsColumn()`: removed the `EP_FixedCol` check, restoring the pre-fix `p->op==TK_COLUMN` test. This is the direct reversal of the fix hunk.
2. `src/whereexpr.c` `exprAnalyze()`: removed `&& !ExprHasProperty(pRight, EP_FixedCol)` from the condition that creates the transposed virtual term (`y=x`) for a comparison. This is the same defect on a second path: in 3.54.1 a later change also excludes FixedCol columns when building transitive terms. Reverting only (1) was not enough to bring the bug back (0 oracle failures).

## Oracle failures
whereG-11.1.1 and whereG-11.1.2 (`unlikely(x=y) AND y='AAA'` and `likely(...)`) return the non-matching row `AAA BBB t2` instead of an empty result.
