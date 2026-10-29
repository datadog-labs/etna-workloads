# Rationale

## Changed hunk
`ext/fts5/fts5_index.c`, `fts5SegIterReverseNewPage()`: removed the
`if( iRowidOff>=pNew->szLeaf ){ FTS5_CORRUPT_ITER(...) }else{...}` guard (the
modern form of the fix's `p->rc = FTS5_CORRUPT`). The iterator again assigns
`pIter->pLeaf = pNew; pIter->iLeafOffset = iRowidOff;` unconditionally, so a
corrupt first-rowid offset beyond `szLeaf` leads to an out-of-bounds varint read.
This is exactly the pre-fix code.

## Oracle
`fts5corrupt6-1.1` fails: expected `1 {database disk image is malformed}`,
got `0 {}` (corruption is not detected). `1.0` (setup) passes.
