# Rationale

## src/window.c, exprListAppendList()
Reverses the fix's only implementation hunk. The fix replaced the loop
`for(pSub=pDup; ExprHasProperty(pSub, EP_Skip); pSub=pSub->pLeft)` with
`sqlite3ExprSkipCollateAndLikely(pDup)`. I restored the loop. EP_Skip marks only
COLLATE wrappers, so `likely(<integer>)` is not skipped, the integer inside it
is not converted to NULL, and the ORDER BY term stays a constant integer inside
the window frame. Version-3.54.1 still has the helper and the same code shape,
so the revert is direct.

## Oracle failure
`window1-70.2` fails (`ORDER BY likely(2)` in a window used from a subquery
with an outer ORDER BY). `window1-70.0` and `70.1` still pass. It is the only
failing case of 349.
