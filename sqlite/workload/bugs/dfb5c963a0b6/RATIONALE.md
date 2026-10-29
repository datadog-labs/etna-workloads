# Rationale

Fix hunk reversed: `sqlite3ExprForVectorField()` in src/expr.c, which added
`sqlite3RenameTokenRemap(pParse, pRet, pVector)` after the `sqlite3ExprDup()`
of the vector element.

In 3.54.1 that code was rewritten: during RENAME (`IN_RENAME_OBJECT`) the
original sub-expression is moved out of the TK_VECTOR list (`*ppVector = 0`)
instead of being duplicated, so its tokens stay mapped. I removed that
rename-mode branch, so the element is always duplicated with no
`sqlite3RenameTokenRemap()` call. That is the pre-fix behaviour. The copy's
tokens are never registered, so the RENAME COLUMN pass can't see them.

I did not touch the second fix hunk (the `sqlite3RenameExprUnmap` call at
`vector_append_error`). 3.54.1 already covers it through
`sqlite3ExprUnmapAndDelete()`, and reverting it isn't needed to restore the bug.

## Oracle failures
test/altertab2.test: altertab2-4.2 and altertab2-4.3. After `RENAME a TO aaa`
or `RENAME d TO ddd`, the trigger's `UPDATE ... SET (c,d)=(a,b)` isn't
rewritten, because the vector-assignment tokens were lost.
