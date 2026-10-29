# Rationale

Fix: dan's 2018-07-09 commit "Fix a bad assert() in window.c". It only touched assert()s in windowAggStep().

## Change (tree/src/window.c, windowAggStep, `if( pWin->pFilter )` block)
Reverses the first fix hunk. The fixed form allowed nArg==0 and checked `x.pList==0` in that case.
In 3.54.1 that is `assert( pWin->bExprArgs || !nArg || nArg==pList->nExpr )` plus
`assert( pWin->bExprArgs || nArg || pList==0 )`. I restored the old unconditional
`nArg==pList->nExpr` comparison (keeping only the bExprArgs guard that was added later).
For a zero-argument aggregate such as count() with FILTER, pOwner->x.pList is NULL, so the assert
dereferences a NULL pointer. The assert is the bug.

The other two fix hunks add `assert( nArg>0 )` before the NEEDCOLL code. They only add
assertions and could not reintroduce a failure, so I left them in place.

## Oracle
window6-10.0 (`count() FILTER (where b<>5) OVER w1`) crashes the testfixture (assert build) with a
NULL dereference. The run stops at 10.0 and the later cases never run.
