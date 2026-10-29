# Rationale

Fix hunk (src/resolve.c, resolveOrderByTermToExprList): `db->suppressErr = 1;` became
`if( IN_RENAME_OBJECT==0 ) db->suppressErr = 1;`, so that errors hit while resolving an
ORDER BY term of a compound SELECT are not hidden during ALTER TABLE RENAME.

In 3.54.1 the line is already unconditional, but the caller (resolveOrderGroupBy)
now resolves a *duplicate* of the term and only resolves the real expression in
rename mode when the duplicate resolved cleanly. That is why simply reverting
the one-liner is a no-op: the real expression never sees the suppressed error path.

Change made (src/resolve.c, resolveOrderGroupBy): in rename mode the real term `pE` is
resolved directly (no duplicate, and no later "second pass" on pE), so the
suppressErr=1 in resolveOrderByTermToExprList hides errors on the expression that
ALTER TABLE keeps. This is the pre-fix situation: suppressed errors in rename mode.
The duplicate is freed only when it is a real copy.

Oracle: altertab-21.3 (`ALTER TABLE a RENAME TO e` with the view from 21.0) now aborts the
testfixture with `Assertion (p->selFlags & SF_Resolved) failed` in
selectAddSubqueryTypeInfo, instead of returning the "error in view c: 1st ORDER BY term
does not match any column in the result set" error. The run is incomplete, so later cases don't run.
