# Rationale

Changed: `tree/ext/fts3/fts3.c`, `fts3InitVtab()`.

Removed the block that, for `content=` tables with no declared columns, removes
the `languageid=` column from `aCol[]` after `fts3ContentColumns()`.
This reverses fix hunk 2 (the added "remove the language id column from the aCol[] array" loop).
The current code uses a copy loop instead of `memmove`, but it is functionally the same block.

Hunks 1 (`fts3ReadExprList`) and 3 (`fts3ColumnMethod`) are still present and
were left unchanged; the bug is fully reproduced by hunk 2 alone.

Effect: with `CREATE VIRTUAL TABLE t2 USING fts4(content=t3_data, languageid=l)`,
the language id column is treated as an indexed user column, so the declared
schema and column counts are wrong.

Oracle: `fts4langid-3.1` onwards fails. The `SELECT ... FROM t2 WHERE t2 MATCH ...`
query raises "vtable constructor failed: t2". Cases 1.* and 2.* still pass.
