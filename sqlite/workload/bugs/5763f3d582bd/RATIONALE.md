# Rationale

Fix hunk (ext/fts5/fts5_index.c, fts5SegIterNext): `assert( pIter->iLeafOffset<=pIter->pLeaf->nn )` was
changed to `assert_nc(...)`, because corrupt records can legitimately violate it.

In 3.54.1 the same inlined block still exists with `assert_nc`. I changed that one line back to a plain
`assert()` (tree/ext/fts5/fts5_index.c, ~line 2415). The comment-only hunk was not reverted.

Oracle failure: fts5corrupt3-73.1 aborts with
`fts5SegIterNext: Assertion 'pIter->iLeafOffset<=pIter->pLeaf->nn' failed` instead of returning
"database disk image is malformed". All earlier cases still pass.
