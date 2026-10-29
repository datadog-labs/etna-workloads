# Rationale

## Change
`ext/fts5/fts5_expr.c`, `sqlite3Fts5ExprClonePhrase()`: removed the block that
copies the original phrase's `Fts5Colset` (`pOrig->pNode->pNear->pColset`) into
`pNew->pRoot->pNear->pColset`.

This reverses the sole implementation hunk of the fix, which added exactly that
copy. The code in 3.54.1 is the same logic with newer macros (`SZ_FTS5COLSET`,
`ALWAYS(pOrig!=0)`). Without it, the cloned phrase used by `xQueryPhrase()`
(and so by bm25()) ignores column filters.

## Oracle failure
`fts5aux-9.3` fails. `SELECT rowid FROM t1('b:a AND b:b') ORDER BY rank` returns
the wrong order, because bm25 counts hits in all columns instead of only
column b. The other 101 cases pass.
