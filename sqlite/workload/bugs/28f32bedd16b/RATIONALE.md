# Rationale

The fix's only implementation hunk (src/pager.c, pagerExclusiveLock) still applied
in 3.54.1 as-is, so it is reversed directly:

- Restored `assert( pPager->eLock==SHARED_LOCK || pPager->eLock==EXCLUSIVE_LOCK )`
  in place of `assert( pPager->eLock>=SHARED_LOCK )`.
- Removed the `eOrigLock` variable, and restored `pagerUnlockDb(pPager, SHARED_LOCK)`
  on lock failure instead of `pagerUnlockDb(pPager, eOrigLock)`.

This is the pre-fix code: it does not allow for the lock being RESERVED when
called (reachable via SQLITE_FCNTL_PERSIST_WAL plus a sequence of journal mode changes).

## Oracle failure
walpersist-4.1 fails: testfixture aborts with
`pagerExclusiveLock: Assertion pPager->eLock==SHARED_LOCK || pPager->eLock==EXCLUSIVE_LOCK failed`.
All other cases pass.
