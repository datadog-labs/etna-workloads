# Rationale

Fix (ticket #2464) added `db->errCode = rc;` in `blobReadWrite()` (src/vdbeblob.c)
so a failed sqlite3_blob_read()/write() sets the connection error code.

In 3.54.1 the equivalent is a single `sqlite3Error(db, rc);` just before
`sqlite3ApiExit()` at the end of `blobReadWrite()`. I removed that call, restoring
the pre-fix behaviour: the return code is correct but `sqlite3_errcode()` /
`sqlite3_errmsg()` are not updated. (Side effect: out-of-range and ABORT cases also
no longer set the error code, which was likewise the case before the fix.)

## Oracle failures
- incrblob-7.5: errcode after write to read-only blob is SQLITE_OK, expected SQLITE_READONLY
- incrblob-7.6: errmsg is "not an error", expected "attempt to write a readonly database"
- incrblob-8.2, incrblob-8.4: errcode SQLITE_OK instead of SQLITE_ERROR
