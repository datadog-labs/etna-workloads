# Rationale

## Change: `tree/src/whereexpr.c`, `exprAnalyzeOrTerm()`

Fix hunk reversed: the introduction of `orTermIsOptCandidate()` in
`src/where.c`. That function made an OR term a candidate for the
OR-to-IN conversion only if, when the right-hand side has an affinity, it
equals the left-hand side's affinity (Ticket #2249). Before the fix, a term
qualified on a matching cursor and column alone.

In 3.54.1 the helper no longer exists. Its logic is inline in the
`okToChngToIN` loop of `exprAnalyzeOrTerm()` (the `affRight`/`affLeft`
comparison). I removed that comparison, so a term whose cursor and column
match is simply marked `TERM_OK`. That is the pre-fix condition.

The other hunks (`orTermHasOkDuplicate`, the `nTerm>=2` assert, the `j<2`
loop bound) are refactors and cleanups, not part of the bug, so I left them.

## Oracle results (`test/where2.test`)

`where2-6.11`, `6.11.2`, `6.11.3` and `6.11.4` fail. They run
`a=b OR a='hello'` and its permutations, where `a` is TEXT and `b` is INTEGER.
The OR is wrongly converted to `a IN (b,'hello')`. The IN comparison skips the
numeric affinity coercion that `a=b` needs, so the join row `123 0123` is no
longer returned.
