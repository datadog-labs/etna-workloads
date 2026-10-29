# Rationale

## Change: tree/src/insert.c, xferOptimization()

Removed the block (guarded by `SQLITE_OMIT_FOREIGN_KEY`) that returns 0 when
`(db->flags & SQLITE_ForeignKeys)!=0 && pDest->u.tab.pFKey!=0`. This reverses the
single implementation hunk of the fix (the manifest hunks are metadata only). The
block is the same code the fix added, adapted to `pDest->u.tab.pFKey` and `db->flags`;
without it the transfer optimization runs even when the destination table has
foreign keys and enforcement is on, so FK constraints are not checked.

## Oracle failures
insert4-7.3 (INSERT..SELECT succeeds instead of "foreign key constraint failed"),
insert4-7.4 (row is inserted), insert4-7.5 and insert4-7.7 (xferopt count is 1, not 0).
