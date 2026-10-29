# Rationale

Fix hunk reversed: `termIsEquivalence()` in src/whereexpr.c (the only implementation hunk).

In 3.54.1 the code already had the post-fix check (6): return 0 unless
`sqlite3ExprCollSeqMatch()` says both operands share a collating sequence.
I restored the pre-fix condition: compute `pColl = sqlite3ExprCompareCollSeq()`
and only reject when `!sqlite3IsBinary(pColl) && !sqlite3ExprCollSeqMatch(...)`.
So when the overall comparison collation is BINARY (e.g. `a=b` with `a` BINARY
and `b` NOCASE, where the left operand's collation wins), the term is wrongly
treated as an equivalence. I also restored the (6a)/(6b) comment, replacing the
current comment text for (6).

Oracle failures:
- transitive1-900: `a=b AND b='ABC'` is wrongly transformed to `a='ABC'`, returning no rows instead of `abc abc`.
- transitive1-570eqp: the plan now uses SEARCH c1 USING INDEX c1x instead of the expected SCAN c1.
