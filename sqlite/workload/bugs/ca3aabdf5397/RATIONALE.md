# Rationale

All changes are in `unixLock()` in `tree/src/os_unix.c` (the POSIX advisory-lock VFS), reversing the `src/os_unix.c` hunks of fix.patch. The `src/test_vfs.c` hunks only add the `xLock` ioerr injection that the oracle test needs. 3.54.1 already contains them, so I left them alone.

1. Comment: restored `RESERVED -> EXCLUSIVE` in place of `RESERVED -> (PENDING) -> EXCLUSIVE`. This reverses the comment hunk.
2. PENDING-byte condition: restored `eFileLock==EXCLUSIVE_LOCK && pFile->eFileLock<PENDING_LOCK`, replacing `==RESERVED_LOCK`. This reverses the second hunk.
3. Removed the `else if( eFileLock==EXCLUSIVE_LOCK ){ ...=PENDING_LOCK }` block that ran right after the PENDING byte was locked successfully. This reverses the third hunk.
4. Restored the trailing `else if( eFileLock==EXCLUSIVE_LOCK )` after `if( rc==SQLITE_OK )` at the end of the function. A failed upgrade to EXCLUSIVE now marks the fd PENDING only at the end, so `pInode->eFileLock` is not PENDING during the lock attempt. This reverses the fourth hunk.

## Oracle result
`pendingrace-1.3` fails. It expects `{1 {database is locked}}` and gets `{1 {database disk image is malformed}}`. A second connection that should have been blocked by the PENDING lock reads the database without rolling back the hot journal, so it sees the corrupt database. This is the spurious corruption error the fix addresses. The other oracle cases pass.
