# Rationale

Changed `sqlite3WalSavepointUndo()` in `tree/src/wal.c`.

The fix added two things:
1. `aWalData[3] = pWal->nCkpt` in `sqlite3WalSavepoint()`.
2. In `sqlite3WalSavepointUndo()`, a check for `aWalData[3]!=pWal->nCkpt` that resets the savepoint to frame 0 when the log has wrapped. It also relaxed the assert.

In 3.54.1 the unmap/`walIndexMap` code has been rewritten, so the `walIndexUnmap` hunk no longer applies. I removed the wrap-detection block and restored the old assert `aWalData[0]<=pWal->hdr.mxFrame`. The savepoint therefore ignores a log restart that happened after it was opened. `WAL_SAVEPOINT_NDATA` and the store of `nCkpt` are left in place, since they are harmless without the check.

## Oracle
`wal-21.2` (in test/wal.test) fails: the assertion `aWalData[0]<=pWal->hdr.mxFrame` fires in `sqlite3WalSavepointUndo`. In a build without assertions, the rollback would silently skip the undo and leave frames from the rolled-back savepoint in the log.
