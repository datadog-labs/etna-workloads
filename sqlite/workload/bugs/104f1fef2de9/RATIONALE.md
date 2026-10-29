# Rationale

Fix hunk: in `pager_end_transaction()`, when dropping to SHARED_LOCK, add `pPager->changeCountDone = 0`.

In 3.54.1 that reset lives in `pagerUnlockDb()` (src/pager.c, ~line 1147), which `pager_end_transaction()` calls for the SHARED_LOCK downgrade. It was unconditional (`changeCountDone = tempFile`). I changed it to run only when `eLock==NO_LOCK`. A commit that drops to SHARED_LOCK therefore leaves `changeCountDone` set, which is the pre-fix behaviour. The next write transaction on the same pager then skips the change-counter increment, so other connections can keep stale caches. This is the same defect the fix removed. The NO_LOCK path (`pager_unlock`) still resets the flag, as it did before the fix.

The change also affects the other SHARED_LOCK callers of `pagerUnlockDb()` (error and rollback paths). They are the same kind of downgrade, so I left them.

## Oracle result
`./check.sh`: test/lock.test aborts at lock-1.3 with
`assert_pager_state: Assertion 'pPager->changeCountDone==0 || pPager->eLock>=RESERVED_LOCK' failed`.
The flag is left set after the lock drops below RESERVED. 61 of 64 oracle cases are reported failing, because the assert kills the run, not because each case fails on its own. In a build without asserts, lock-6.2 and the later lock-6.x cases would see stale data. I did not run that build.
