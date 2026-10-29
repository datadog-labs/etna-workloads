# Rationale

Fix hunk (src/alter.c, renameColumnFunc) moved the generated-column loop
(`sqlite3WalkExpr` over each column's expression) inside the
`if( bFKOnly==0 )` block. In 3.54.1 the loop uses `sqlite3ColumnExpr()`
rather than `aCol[i].pDflt`, but is otherwise the same code. I moved the
closing `}` of that block back to before the `#ifndef SQLITE_OMIT_GENERATED_COLUMNS`
loop, so the walk runs again even when the table being walked is not the
table being altered (bFKOnly!=0, sCtx.pTab is a different table).

Effect: generated column expressions in other tables get their
references to a same-named column renamed.

Oracle failure: altercol-22.0 (t2's `extra AS (c + 1)` / unrelated tables
with a column named like the renamed one are wrongly rewritten).
