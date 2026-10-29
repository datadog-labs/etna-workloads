# Rationale

## src/vdbeblob.c, blobReadWrite()
Reverses the fix's hunk that changed the range check from
`(iOffset+n)>p->nByte` to `n<0 || iOffset<0 || (iOffset+n)>p->nByte`.
In 3.54.1 the check was `n<0 || iOffset<0 || ((sqlite3_int64)iOffset+n)>p->nByte`;
I removed the `n<0 || iOffset<0 ||` terms, restoring the pre-fix check that only
tests the upper bound. Negative offset/amount with a sum within nByte passes
the check and reaches sqlite3BtreePutData() instead of returning SQLITE_ERROR.
(The sqlite3Error/mutex reordering from the fix is already covered by the
later unconditional `sqlite3Error(db, rc)`, so it was left alone.)

## Oracle failures
incrblob-8.3 (write with offset -1 returns OK instead of SQLITE_ERROR),
incrblob-8.4 (errcode SQLITE_OK instead of SQLITE_ERROR), and
incrblob-8.5 / 8.7 (the write at offset -1 corrupted the row: "database disk
image is malformed").
