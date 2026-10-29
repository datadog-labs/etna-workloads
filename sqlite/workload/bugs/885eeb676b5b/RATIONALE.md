# Rationale

Fix: ticket bc8d94f0fbd633fd9a051e3 (RENAME COLUMN with redundant UNIQUE/PRIMARY KEY constraints).
In 3.54.1 the fix is intact; I reverted its three functional hunks (the assert hunk and sqliteInt.h comment are not behavioural).

- src/build.c (sqlite3CreateIndex, redundant-index branch): removed the `if( IN_RENAME_OBJECT ){ pIndex->pNext = pParse->pNewIndex; pParse->pNewIndex = pIndex; pIndex = 0; }` block. Reverses the build.c hunk. The redundant index is again freed immediately, so tokens in it are not retained for the rename walk.
- src/alter.c renameColumnFunc: removed the loop walking `sParse.pNewIndex` list aColExpr. Reverses the alter.c hunk 3.
- src/alter.c renameParseCleanup: restored single `if( pParse->pNewIndex ) sqlite3FreeIndex(...)` instead of freeing a list. Reverses hunk 2 (and the local `pIdx`).

## Oracle failures
altercol-20.100 (redundant UNIQUE(aaA), PRIMARY KEY(aAa), UNIQUE(aAA) then RENAME) aborts with
`renameTokenCheckAll: Assertion p->p!=pPtr failed` (dangling rename token pointing at freed index);
without asserts the rename would miss those column references. Later cases are not reached.
