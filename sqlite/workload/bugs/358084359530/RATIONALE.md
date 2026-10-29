# Rationale

## src/where.c, whereLoopAddVirtual()
Reverses the single implementation hunk of the fix. The condition guarding
the additional xBestIndex() calls is restored to
`rc==SQLITE_OK && (mBest = (pNew->prereq & ~mPrereq))!=0`, dropping the
`|| bIn` term, and the comment is restored to its pre-fix text. The code
around it was unchanged apart from the extra `bRetry` argument, so the
reversal is exact.

When the first xBestIndex() call (all terms usable) yields a plan with no
prerequisites that uses an IN(...) constraint, the planner no longer makes
the second call with the IN marked unusable. That call is the one that lets
it pick a cheaper plan when the IN list is large.

## Oracle failure
`bestindex1-4.1` fails. It expects two xBestIndex calls, the second with
`{op eq column 2 usable 0}`. It gets only the first call.
