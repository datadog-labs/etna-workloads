# Rationale

## Change
`tree/ext/fts3/fts3_write.c`, `fts3SegReaderNext()`: removed the corruption
check that follows `pReader->pOffsetList = 0;`. It tested that the doclist
does not extend past the end of the b-tree node, that the final doclist byte
is 0, and that `nDoclist!=0`. The function now returns `SQLITE_OK` straight
after setting `aDoclist`/`pOffsetList`.

## Fix hunk reversed
The fix replaced a bare `assert( pNext<&aNode[nNode] )` with this check,
returning SQLITE_CORRUPT. Before the fix, nothing validated `nDoclist`
against the node size. In 3.54.1 the check has the same purpose, with
`FTS_CORRUPT_VTAB`, a `nPopulate` guard for incremental reads and an added
`nDoclist==0` test. Removing it restores the pre-fix state: a corrupt
`nDoclist` is accepted, and later code reads past the node buffer.
The earlier `nSuffix`/`nPrefix` checks are left alone because they were not
part of this fix.

## Oracle results
`test/fts3corrupt.test`: `fts3corrupt-1.3` and `fts3corrupt-1.3.1` fail. The
INSERT into a table whose segdir root was corrupted no longer returns
"database disk image is malformed". The other 30 cases pass (38 oracle
entries listed; 32 run). `fts3defer2.test` has no failing oracle cases.
