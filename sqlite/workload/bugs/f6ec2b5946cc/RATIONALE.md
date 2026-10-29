# Rationale

Fix hunk (src/os_unix.c, `dotlockCheckReservedLock`) replaced a dotfile existence
check (`osAccess(lockingContext)`) with "caller holds SHARED, so no other client
can hold RESERVED: *pResOut=0".

In 3.54.1 the function had been rewritten to apply that logic only when
`eFileLock>=SHARED_LOCK`, falling back to `osAccess` otherwise. I reverted it to
the pre-fix behaviour: always `*pResOut = osAccess(lockingContext,0)==0`.
With unix-dotfile, the caller's own dotfile makes the check report RESERVED held,
so hot-journal detection treats the db as locked/reserved and does not roll back
the hot journal.

Oracle: `lock5-2.dotfile.5` fails ("database disk image is malformed" instead of
`ok`), since the hot journal is not rolled back before integrity_check.
