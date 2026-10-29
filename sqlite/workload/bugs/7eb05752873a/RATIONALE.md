# Rationale

## src/wal.c, sqlite3WalUndo()
Fix hunk: `walCleanupHash(pWal);` -> `if( iMax!=pWal->hdr.mxFrame ) walCleanupHash(pWal);`.
Version 3.54.1 still contains the guarded form; I removed the guard, restoring the
pre-fix unconditional `walCleanupHash(pWal)` call. This is the same code, so the
reversal is exact. When nothing was written to the WAL (iMax==mxFrame after the
header restore), walCleanupHash runs anyway and, after a full checkpoint, touches
a shm page that this connection hasn't mapped.

## Oracle failure
test/wal9.test case wal9-1.7 (BEGIN; INSERT; ROLLBACK on a connection with only
the first shm chunk mapped) aborts with
`Assertion 'pWal->nWiData>walFramePage(pWal->hdr.mxFrame)' failed` in walCleanupHash,
the assert the fix targeted. Cases 1.0-1.6 pass.
