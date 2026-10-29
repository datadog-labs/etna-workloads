# Rationale

## Hunk changed: `fts5StructureDecode` in ext/fts5/fts5_index.c
The fix added, after decoding each segment's iSegid/pgnoFirst/pgnoLast, a check
`pgnoLast<pgnoFirst` -> FTS5_CORRUPT. In 3.54.1 this check survives as
`if( pSeg->pgnoLast<pSeg->pgnoFirst || pSeg->pgnoLast>FTS5_MAX_PGNO )`
(the second term was added later). I removed that whole check, which restores
the pre-fix decoder: a structure record with pgnoLast<pgnoFirst is accepted.
The `pSeg` local was already present, so nothing else changed.

## Oracle failure
`fts5corrupt3-16.1` fails: the corrupt db in test 16.0 is no longer rejected
with "vtable constructor failed: t1" (the segment range is accepted and the
integrity-check proceeds with a bogus segment, the original null-deref path).
