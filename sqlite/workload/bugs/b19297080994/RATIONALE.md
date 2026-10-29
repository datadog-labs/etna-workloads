# Rationale

Fix: the RESTRICT trigger's SELECT (in `fkActionTrigger`, src/fkey.c) named the
child table without a schema, so it was looked up in the wrong schema
(e.g. `main.c1` instead of `aux.c1`). The fix added the schema name
(`tDb`) to `sqlite3SrcListAppend`.

In 3.54.1 the schema is pinned by `pItem->fg.fixedSchema = 1;` and
`pItem->u4.pSchema = pTab->pSchema;` on the SrcItem. I removed those two lines, so the
child table is again given by name only and resolved by the normal
search order (temp, main, attached). This is the same defect as the fix's
`tDb` hunk. The comment-only hunks of the fix are not reverted.

Oracle: `fkey8-6.3` fails with "FOREIGN KEY constraint failed". `main.c1`
holds a row (123), so deleting from `aux.p1` scans the wrong `c1`.
