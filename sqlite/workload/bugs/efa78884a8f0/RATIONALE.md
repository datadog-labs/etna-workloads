# Rationale

## src/window.c, exprListAppendList()
Reverses the fix hunk that made the bIntToNull step look through
EP_Skip wrapper nodes (COLLATE) to find the constant integer.
In 3.54.1 that loop is `sqlite3ExprSkipCollateAndLikely(pDup)`; I removed it
and test `pDup` itself again, as the pre-fix code did. `PARTITION BY 6 COLLATE binary`
is then no longer converted to NULL, so the constant partition term is kept.

## Oracle failures
window1-52.3, window1-52.4 (the fix's added tests) and window1-70.2 fail.
