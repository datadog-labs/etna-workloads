# Rationale

## Hunk 1: src/vtab.c, sqlite3VtabBegin()
Reverses the fix's only implementation hunk. The fix replaced
`if( iSvpt ) rc = sqlite3VtabSavepoint(db, SAVEPOINT_BEGIN, iSvpt-1);`
with a direct call to the newly begun vtab's own xSavepoint (setting its
iSavepoint). The pre-fix line is restored verbatim. It calls xSavepoint on
*every* vtab in db->aVTrans, not just the one that was just begun, so vtabs
already in the transaction get a duplicate xSavepoint(iSvpt-1) call.

## Hunk 2: ext/fts3/fts3.c, fts3SavepointMethod()
Reversing hunk 1 alone does not fail any oracle case. The duplicate calls do
happen (checked with a debug print), but today's fts3 tolerates them because
its assertion is `assert( pTab->mxSavepoint<=iSavepoint )`. I tightened it to
the strict `<`, which I believe is how the assertion looked in 2016. I did not
verify that against 2016 history. It is not a hunk of the fix. It is the
fts3 side of the same defect: fts3 must not see a repeated xSavepoint at the
same level. Without it the duplicate call is harmless in this tree.
This is a debug-build assert only (the mxSavepoint check is TESTONLY).

## Oracle failure
`fts3conf-4.3.1` (a savepoint with writes to two fts4 tables, then
ROLLBACK TO) aborts with
`fts3SavepointMethod: Assertion 'pTab->mxSavepoint<iSavepoint' failed`.
The run is incomplete, so later cases (4.3.2, 4.4.x) did not run.
The cause is that t01 gets a second xSavepoint(0) when t02 is begun.
