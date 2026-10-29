# Rationale

Fix hunk (src/where.c, sqlite3WhereBegin): moved `pWInfo->iContinue = pWInfo->a[i-1].addrCont;`
from after the per-table loop into the loop body, so an empty FROM clause (nLevel==0) no longer reads `a[-1]`.

In 3.54.1 the loop is the `for(ii=0; ii<nTabList; ii++)` code-generation loop in `sqlite3WhereBegin`
(it sets `pWInfo->iContinue = pLevel->addrCont;` per iteration). I reverted it to the old form:
the assignment is removed from the loop body and placed after the loop as
`pWInfo->iContinue = pWInfo->a[ii-1].addrCont;`. With nTabList==0 this reads `a[-1]`, overwriting the
initial label (set at `pWInfo->iBreak = pWInfo->iContinue = MakeLabel`) with garbage/0.

## Oracle failures
Every fuzz.test case after fuzz-1.1 fails: the first empty-FROM query hits
`Assertion pWInfo->iContinue!=0 failed` in sqlite3WhereContinueLabel and the run aborts
(including fuzz-1.18, the case the fix added).
