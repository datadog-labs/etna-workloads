# Rationale

## Changed hunk: src/wal.c, walIndexReadHdr()
Reverses the fix hunk that let walIndexReadHdr() cope with the WRITER lock
already being held by the caller (`bWriteLock = pWal->writeLock`; only lock
and unlock if it was not already held). The pre-fix code unconditionally
calls walLockExclusive(WAL_WRITE_LOCK) when the header is bad, and then
unconditionally resets `writeLock=0` and unlocks. The pre-fix
`assert( badHdr==0 || pWal->writeLock==0 )` was dropped in 3.54.1 and is not
restored. Today's `writeLock=2` and `walDisableBlocking()` before recovery
are later additions and are kept.

The other fix hunks (os_unix.c `n==1` assert, ckptLock asserts in
BeginReadTransaction, walDisableBlocking around the checkpoint's
walIndexReadHdr) are asserts or have been redesigned/covered elsewhere
(walIndexReadHdr/recovery now disables blocking itself), so they were not touched.

## Oracle failures
walsetlk-1.7 onward fail: test 1.7 (checkpoint after corrupting the shm) hits
`unixShmLock: Assertion flags!=(EXCLUSIVE|LOCK) || 0==(p->exclMask & mask)`,
because the already-held WRITER lock is re-requested; the run aborts, so
43 of 50 oracle cases fail.
