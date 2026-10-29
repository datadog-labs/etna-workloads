# Rationale

## src/select.c, selectCheckOnClausesExpr()
Reverses the single implementation hunk of the fix. 3.54.1 already had the fixed
logic: when `iJoin>=0`, walk left from the referenced table's position in the
SrcList looking for the iJoin cursor. I restored the pre-fix test
`pCtx->iJoin>=0 && iTab>pCtx->iJoin`, which assumes cursor numbers increase in
SrcList order. (The old `pCtx->iJoin` truthiness check became `>=0` since iJoin
is now -1 when unset.)

That assumption fails when cursors are not allocated in order, e.g. the
recursive CTE's FROM clause in with5-410, so a valid query is rejected.

## Oracle failure
with5-410 fails with `Error: ON clause references tables to its right`
(expected `1`). All other cases pass.
