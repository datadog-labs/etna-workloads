# Rationale

## Change
`tree/src/alter.c`, `renameUnmapSelectCb()`: removed the line
`if( pParse->nErr ) return WRC_Abort;` at the top of the function.

This reverses the single implementation hunk of the fix, which added exactly that
line. The line is still present verbatim in 3.54.1, so removing it restores the
pre-fix code. Without it, the callback proceeds when a prior error left
`p->pEList` NULL, and the `ALWAYS(p->pEList)` is no longer always true for faulty
input.

## Oracle failure
`altertab3-20.10` (the test the fix added) crashes with
`renameUnmapSelectCb: Assertion '0' failed`. The test creates an index on an
expression containing a CTE `IN ()` subquery that errors with
"no tables specified", then runs `ALTER TABLE ... RENAME`. All earlier cases
pass.
