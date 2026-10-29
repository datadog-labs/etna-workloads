# Rationale

Fix hunk reversed: `src/vdbeblob.c` `blobReadWrite()` range check
`((sqlite3_int64)iOffset+n)>p->nByte` -> `(iOffset+n)>p->nByte` (32-bit int overflow).
The line is identical to the pre-fix code, so the two are equivalent.

Not reverted: the `sqlite3_blob_open()` `*ppBlob = 0` reordering. It only applies under
SQLITE_ENABLE_API_ARMOR, and the oracle does not test it.

Oracle failure: incrblob2-6.2b (`sqlite3_blob_read $rdHandle 2147483647 2147483647`)
overflows to a negative sum, passes the range check, and hits the assertion
`(u64)offset+(u64)amt <= (u64)pCur->info.nPayload` in accessPayload. In a non-assert
build it would read out of bounds. Later tests (6.3b/6.3c) did not run because of the abort.
