# Rationale

Fix hunk (src/delete.c, sqlite3GenerateIndexKey) removed the code that, after
OP_MakeRecord, applied the index affinity string as P4 when the table is a view.
That made automatic-index entries on views get affinities applied, which
disagrees with the view column values actually compared.

In 3.54.1 the function is unchanged except that `Table.pSelect` no longer exists;
views are identified by `IsView(pTab)`. I re-added the block in
src/delete.c with `IsView(pIdx->pTable)` as the equivalent condition.

Oracle failure: `cast-9.0` (the CAST(0.0 AS NUMERIC) view joined via automatic
index returns wrong result instead of `0.0`).
