# Rationale

Fix hunk (ext/fts5/fts5_index.c, fts5DecodeFunction): added
`else if( iPgidxOff>n ){ rc = FTS5_CORRUPT; goto decode_out; }` when the leaf's
szLeaf (pgidx offset) exceeds the record size.

In 3.54.1 that hunk is still present, but reversing it alone does not bring the
bug back: a later check (`if( nDoclist+iOff>n )` before fts5DecodeDoclist)
also catches szLeaf>n, since with iPgidxOff>n, iTermOff==0 and
iOff+nDoclist == szLeaf.

Changes (both in fts5DecodeFunction, non-detail=none branch):
1. Removed the `else if( iPgidxOff>n )` corruption check (reverses the fix hunk).
2. Removed the later `nDoclist+iOff>n` check, the second path covering the same
   case (same defect: szLeaf beyond end of the record unvalidated).

Oracle: fts5corrupt3-34.1 fails. fts5_decode() on the corrupt t1_data leaf no
longer returns "database disk image is malformed"; it reads past the record and
returns a different result/error.
