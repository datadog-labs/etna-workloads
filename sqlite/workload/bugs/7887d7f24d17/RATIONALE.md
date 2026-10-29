# Rationale

## Change: src/wherecode.c, `sqlite3WhereCodeOneLoopStart`'s IN-loop setup (codeINTerm area, ~line 764)

Fix hunk reversed: the fix changed `for(i=iEq;i<pLoop->nLTerm; i++, pIn++)` to
`i++` and moved `pIn++` inside the `if( pLoop->aLTerm[i]->pExpr==pX )` block.
In 3.54.1 the code is the post-fix form (same loop, `pIn++` at the end of the
if-block). I restored the pre-fix form: `pIn++` in the for-increment, removed
from the if-block.

Equivalence: `pIn` now advances once per index term, not once per term that
belongs to the IN expression. `aInLoop` is sized for `nEq` entries, so when
other terms (here the `(c,d)` IN terms) sit between this IN's terms, `pIn`
runs past the end of the allocation: a buffer overrun, as in the original bug.

## Oracle failures
`test/rowvalue.test` case `rowvalue-10.0` (the case the fix added) fails with
an assertion: `sqlite3VdbeGetOp: Assertion (addr>=0 && addr<p->nOp)` failed.
It comes from the corrupted/overrun aInLoop entries. The remaining rowvalue
cases pass before it.
