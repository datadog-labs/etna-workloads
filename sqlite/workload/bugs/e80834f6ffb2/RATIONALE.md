# Rationale

## Changed hunk
`ext/fts5/fts5_index.c`, `fts5StructureDecode()`: removed the check, right after
the nLevel/nSegment varints are read, that returns FTS5_CORRUPT when either value
is outside [0, FTS5_MAX_SEGMENT].

This reverses the fix's only implementation hunk, which added
`if( nLevel>FTS5_MAX_SEGMENT || nSegment>FTS5_MAX_SEGMENT ) return FTS5_CORRUPT;`.
In 3.54.1 the check also tests `<0`. That part was added later for the same defect,
so it is removed along with the rest. Without the check, a corrupt structure
record's nLevel drives the allocation size (`SZ_FTS5STRUCTURE(nLevel)`) and the
per-level loop, so a bogus level count is no longer rejected up front.

## Oracle results
`fts5corrupt3-17.1` and `fts5corrupt3-20.1` fail. 17.1 is the test the fix added.
With the check gone, the corrupt schema/structure record no longer produces the
expected `vtable constructor failed: t1` error. The other 2020 cases pass.
