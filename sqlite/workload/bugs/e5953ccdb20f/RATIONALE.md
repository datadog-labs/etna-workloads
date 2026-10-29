# Rationale

Fix e5953ccdb20f: `sqlite3PagerSetJournalMode()` could drop the database lock
to SHARED when leaving PERSIST/TRUNCATE mode without clearing
`changeCountDone`.

## Changes (tree/src/pager.c)

1. `sqlite3PagerSetJournalMode()`: removed the `if( pPager->eLock>=RESERVED_LOCK )`
   shortcut the fix added, restoring the pre-fix unconditional sequence
   (SharedLock / lock RESERVED / delete journal / `pagerUnlockDb(SHARED_LOCK)`
   or `pager_unlock`). Also dropped the `assert( state==PAGER_OPEN || state==PAGER_READER )`
   that only makes sense with the shortcut. The fix's `assert( eState!=PAGER_ERROR )`
   was left alone (assert only).
2. `pagerUnlockDb()`: removed `pPager->changeCountDone = pPager->tempFile;`
   (ticket fb3b3024ea238d5c). Same defect, fixed a second time later: the
   unlock path itself now clears the flag, so reverting hunk 1 alone does not
   reproduce the bug. With it removed, unlocking leaves `changeCountDone` set
   while `eLock < RESERVED_LOCK`.

## Oracle result

Hunk 1 alone: 0 oracle failures. With both, test/jrnlmode.test aborts at
jrnlmode-2.1 with `assert_pager_state: Assertion
'pPager->changeCountDone==0 || pPager->eLock>=RESERVED_LOCK' failed`, so
jrnlmode-2.1 onward (77 of 97 cases, including the new 8.x cases) fail. This is
the very invariant the fix protects (changeCountDone set while unlocked).
