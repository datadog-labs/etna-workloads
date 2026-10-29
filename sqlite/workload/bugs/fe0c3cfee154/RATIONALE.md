# Rationale

Changed: `tree/ext/fts5/fts5_index.c`, `fts5MergeRowidLists()`.

Reverses the fix hunk `@@ -4408,16 +4442,18 @@ fts5MergeRowidLists`, the part that moved
`fts5NextRowid(p2, ...)` to after the `iRowid1==iRowid2` check. In this tree the
fix is still in place. I restored the pre-fix order: p2 is advanced first, then
`iRowid1==iRowid2` is compared against p2's *next* rowid. A rowid present in both
lists is therefore not skipped in p1, and it is emitted twice. The output is no
longer strictly ascending, and the delta varint can go negative. The fix's
`assert( iOut==0 || iRowid1>iOut )` / `iRowid2>iOut` lines were left as they are,
since they are part of the fix and the other hunks only add them.

Other hunks of the fix are not reverted; they are detail=none/columns specific and
this one is the smallest self-contained defect.

## Oracle failure
`fts5simple2-12.1` aborts with `Assertion 'iOut==0 || iRowid1>iOut' failed` in
fts5MergeRowidLists (prefix-query merge of doclists with overlapping rowids).
