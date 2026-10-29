# Rationale

## Change: src/window.c, windowAggStep()
Fix hunk reversed: the one adding, inside `if( pWin->bExprArgs )`, a loop that
rewrites every `OP_Column` on `pWin->iEphCsr` in the freshly coded argument
expressions to read from `csr` (the cursor actually positioned on the row being
stepped/inverted). I removed the equivalent loop in 3.54.1 (it uses
`pMWin->iEphCsr`, `iOp`/`iEnd`, and the local `iOp`/`iEnd` variables). Without it,
argument expressions such as `json(j)` read from the ephemeral-table cursor's
current row rather than the row of `csr` (the "start"/"end" cursors used for
AggStep/AggInverse with EXCLUDE or non-trivial frames), giving wrong values.

The assert hunk of the fix is already present in 3.54.1 and is left alone
(it only loosens asserts; not behavioural).

## Oracle failures
17 of 71 windowB cases fail (wrong results), e.g. windowB-3.3 (EXCLUDE TIES),
3.4/3.5 (ROWS frames), 10.2/10.3 (e.g. `{["one","one"]}` instead of
`["one","two"]`).
