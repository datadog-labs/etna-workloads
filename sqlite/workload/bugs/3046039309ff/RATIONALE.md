# Rationale

Fix hunk reversed: the removal of `p1->bDel = p2->bDel;` in `fts5MultiIterDoCompare()`
(ext/fts5/fts5_index.c) for the case where two segment iterators have the same term and rowid.
The line is re-added verbatim. In 3.54.1 the other hunks (pSeg->bDel handling in
fts5DoSecureDelete, bDel handling in fts5FlushOneHash) are still present, but the fix
relied on the winning iterator's bDel not being overwritten by the older segment's flag.
With the line restored, a secure-delete of a rowid/term pair that follows a legacy delete
of the same pair sees the wrong bDel flag and corrupts the index.

Failing oracle case: fts5secure6-4.3 (integrity-check) -> "fts5: checksum mismatch for table "t1"".
