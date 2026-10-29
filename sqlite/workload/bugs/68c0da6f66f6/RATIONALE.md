# Rationale

Reverted one hunk of the fix (fts5_index.c, `fts5SegIterNext_None`):
`while( pIter->pSeg && iOff>=pIter->pLeaf->szLeaf )` -> `if( ... )`.

The fix made the detail=none iterator loop over pages, because with
secure-delete a page can be left empty (only the 4-byte header). With `if`, the
iterator advances only one page and then reads from an empty page, so entries
are skipped or misread. This is the code the fix changed, restored to its
pre-fix form.

The other fix hunks were not reverted. The `fts5DoSecureDelete` refactor
and the detail=none handling in `fts5FlushOneHash` and `fts5SecureDeleteOverflow`
are still present.

Failing oracle case: fts5secure5-4.1 ("database disk image is malformed").
It deletes 500 identical-term rows one by one in a detail=none secure-delete
table with pgsz=64, running integrity-check after each delete.
