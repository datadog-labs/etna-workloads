# Rationale

Fix hunk reversed: the added `if( iOff>pLast->szLeaf ){ p->rc = FTS5_CORRUPT; return; }`
check in `fts5SegIterReverse()` (ext/fts5/fts5_index.c) before the rowid varint is read
from `pLast`. In 3.54.1 the check is written as `FTS5_CORRUPT_ITER(p, pIter)` in the same
place; I removed those 4 lines. `fts5GetVarint()` then reads from `pLast->p[iOff]` with
`iOff` past the end of the leaf (out-of-bounds read) on corrupt records.
The other hunk of the fix (a blank-line removal) is not behavioural.

Oracle: `fts5corrupt5-1.1` fails (expected `database disk image is malformed`; the query
no longer reports corruption). The other cases still pass.
