# Rationale

Fix hunk (src/select.c, `sqlite3SelectAddColumnTypeAndCollation`): added
`while( pSelect->pPrior ) pSelect = pSelect->pPrior;` so view column types and
collations come from the leftmost SELECT of a compound.

In 3.54.1 that function was renamed `sqlite3SubqueryColumnTypes` and still has
the identical line right after the `IN_RENAME_OBJECT` early return. I deleted it.
Without it, a compound view's types are derived from the rightmost SELECT
(`pSelect` is the last in the pPrior chain), as before the fix.

Oracle cases that fail: view-30.2 (columns come out with empty types instead
of INT/BLOB) and view-31.1.
