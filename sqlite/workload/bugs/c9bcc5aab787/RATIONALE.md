# Rationale

Fix: the multi-index-OR pushdown of auxiliary WHERE terms (`sqlite3WhereCodeOneLoopStart`,
src/wherecode.c) must skip terms containing subqueries (`EP_Subquery`, tag-20220303a).

## Changes (src/wherecode.c only)

1. Removed `if( ExprHasProperty(pExpr, EP_Subquery) ) continue;  /* tag-20220303a */`
   - reverses the fix's added line directly; subquery terms are pushed into the OR sub-WHEREs again.
2. Removed `if( (pWC->a[iTerm].eOperator & WO_ALL)==0 ) continue;`
   - Reversing only (1) did not make oracle 4.1 fail: in 3.54.1 `false OR EXISTS(..)` is
     simplified to a bare EXISTS term whose eOperator is 0, so this filter skipped it
     (in 2022 it was still a WO_OR term and passed the filter). The filter is the line the fix
     rewrote (WO_ALL -> WO_SINGLE); with it gone, the pre-fix behaviour "push every
     ready term" applies to today's term shapes. The comment block is untouched.

The `/* ... */` comment describing the 2022-03-03 rule is left in place.

## Oracle failures

`test/where7.test` case `4.1` fails: the EXISTS subroutine is coded in the first OR branch
(covering index t1zxy) and invoked from the second (index on y), tripping the assertion
`p2<(u32)pC->nField` in sqlite3VdbeExec (a wrong column read in non-debug builds).
All other where7 cases still pass.
