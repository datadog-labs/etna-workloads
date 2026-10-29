# Rationale

Fix hunk (src/attach.c, `sqlite3FixSelect`): added a loop that calls
`sqlite3FixSelect()` on each `pSelect->pWith->a[i].pSelect`, so CTE bodies in
views/triggers get schema-fixed and checked for parameters.

In 3.54.1 `sqlite3FixSelect` is just `sqlite3WalkSelect()`, and the equivalent
loop lives in the walker callback `fixSelectCb()` (src/attach.c), which walks
each CTE's select. I removed that `if( pSelect->pWith ){...}` block, so WITH
clauses are no longer visited by the fixer, which is the pre-fix behaviour.

## Oracle failures (test/with4.test)
- with4-120: view with a CTE referencing `aux.t2` is accepted (no error).
- with4-200: trigger with a CTE referencing `aux.t2` is accepted; this also
  causes with4-210 to fail with "trigger r1 already exists".
- with4-210: it fails as a consequence of 200 (the trigger now exists).
  The parameter check in the CTE is likewise skipped.
