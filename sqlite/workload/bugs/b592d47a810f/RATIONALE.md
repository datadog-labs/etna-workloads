# Rationale

Fix hunk reversed: in `whereLoopAddBtreeIndex()` the skip-scan condition gained
`saved_nEq==pNew->nLTerm` (no skip-scan if earlier index terms are already used
by non-equality constraints).

In 3.54.1 that guard is still present, but `pNew->nLTerm` had since been
restored to `saved_nLTerm` just before the skip-scan block, so removing only the
guard changes nothing (check passed with 0 failures). Changes in `src/where.c`:

1. Removed `&& saved_nEq==pNew->nLTerm` from the skip-scan condition (the
   fix's hunk).
2. Removed the `pNew->nLTerm = saved_nLTerm;` restore that precedes the
   skip-scan block, so nLTerm holds the value left by the last range term, as
   when the guard was needed. Without it the guard being absent matters again.
3. Added `pNew->nLTerm = saved_nLTerm;` after the skip-scan block, so the
   stale value does not leak to callers (limits the change to the skip-scan decision).

Effect: a skip-scan slot is appended after a range term in aLTerm while nEq
counts it as a skipped column, so aLTerm and nEq/nSkip disagree.

Failing oracle cases: skipscan1-4.10 (the ticket's test), 2.3, 2.3eqp, 5.0,
8.1, 8.1eqp, 8.2, 9.2, 9.3. 8.1 aborts with the assertion
`pTerm!=0` in codeAllEqualityTerms.
