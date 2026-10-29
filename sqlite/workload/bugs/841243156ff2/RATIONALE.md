# Rationale

Changed one line: `ext/fts5/fts5_index.c`, `fts5MergeRowidLists()`:
`fts5NextRowid(p2, &i2, &iRowid2)` -> `fts5NextRowid(p1, &i2, &iRowid2)`.

This reverses the fix's last hunk (`fts5MergeRowidLists`, `p1` -> `p2`). The detail=none
prefix-merge code still exists in 3.54.1 with the same shape. The second list's
first rowid is read from p1's buffer using p2's offset, so the first rowid of list 2 is wrong.
This corrupts the merged rowid list for `b*` prefix queries on detail=none tables.

The other fix hunks (reverse iteration, merge, `fts5ChunkIterate`) were not reverted because
the code has been restructured since 2015 and detail=none is now handled differently.

## Oracle failures
fts5simple2-5.1, 8.0.1, 8.0.4, 8.1.1, 8.2.1. 5.1 is a test the fix added
(`SELECT rowid FROM t1('b*')` on a detail=none table); it returns wrong rowids.
