# Rationale

## Change
`tree/src/window.c`, `sqlite3WindowRewrite()`: removed the `&& p->pPrior==0` condition
from the `if( p->pWin ... )` guard.

Reverses the fix's only implementation hunk (`if( p->pWin && p->pPrior==0 )` -> `if( p->pWin )`).
In 3.54.1 the guard has extra clauses (SF_WinRewrite, IN_RENAME_OBJECT ALWAYS()s), so
the hunk could not be reversed textually; removing the pPrior clause restores the
pre-fix behaviour: window rewriting is applied to compound SELECT members that have
a prior SELECT, rather than only the first/leftmost-handled one.

## Oracle failures
`window1-13.2.2` (SELECT ... rank() OVER ... UNION ALL SELECT ... rank() OVER ...)
hits `Assertion '0' failed` in sqlite3WindowRewrite, aborting the run, so 13.3-13.5
(UNION/EXCEPT/INTERSECT) are not reached.
