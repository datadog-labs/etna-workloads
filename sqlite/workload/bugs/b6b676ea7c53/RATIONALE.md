# Rationale

## src/fkey.c, fkActionTrigger()
Fix hunk reversed: the fix replaced `sqlite3PExpr(TK_ID, ..., &token)` (which dequoted the
token) with `sqlite3ExprAlloc(db, TK_ID, &token, 0)` (no dequote) for the "old", "new",
to-column and from-column identifiers. In 3.54.1 the fixed form is
`sqlite3ExprAlloc(db, TK_ID, &tok, 0)`; the pre-fix behaviour (dequote the token) is
`sqlite3ExprAlloc(..., 1)`. The column names come from `zCnName`, which is already
dequoted, so dequoting again corrupts names beginning with a quote character
(e.g. column `"2`).

The trigger.c hunk (targetSrcList) was not reverted: that function no longer exists in
that form in 3.54.1.

## Oracle failures
fkey1-4.1 hits `Assertion z[i] failed` in sqlite3Dequote (double-dequoting a name
that starts with `"`); the run aborts, so fkey1-4.2 and all later cases are
reported as failing (incomplete run).
