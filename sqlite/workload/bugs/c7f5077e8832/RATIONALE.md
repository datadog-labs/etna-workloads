# Rationale

## src/select.c, srclistRenumberCursors()
Reverses the single fix hunk. The fix made a recursive FROM-clause item reuse
an already-assigned mapping in aCsrMap (`!isRecursive || map==0`) instead of
always allocating a fresh cursor. In 3.54.1 the code is the same logic with
the aCsrMap[...+1] offset and `isSubquery`/`u4.pSubq`; I restored the
pre-fix unconditional `pItem->iCursor = aCsrMap[iCursor+1] = pParse->nTab++;`.
Multiple references to the same recursive CTE now get different cursors,
so the recursive-table reference no longer matches the queue cursor.

## Oracle failure
test/unionall.test unionall-7.1 (the added dbsqlfuzz case) fails with
`Assertion 'pC!=0' failed` in sqlite3VdbeExec (null cursor).
