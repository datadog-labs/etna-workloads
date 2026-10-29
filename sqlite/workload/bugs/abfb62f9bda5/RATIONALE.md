# Rationale

Fix (ticket f3e5abed55): in `vdbeCommit()`, take an EXCLUSIVE lock on every
database with an open write transaction (`sqlite3PagerExclusiveLock()`)
*before* a super-journal is created, so that SQLITE_BUSY is reported cleanly
and no stray super-journal is left behind or half-committed state produced.

## Change

`src/vdbeaux.c`, `vdbeCommit()`: removed `rc = sqlite3PagerExclusiveLock(pPager);`
from the loop that counts write transactions. This reverses the fix hunk that
added `rc = sqlite3PagerExclusiveLock(sqlite3BtreePager(pBt));` to that loop.
Other fix hunks (the `sqlite3PagerExclusiveLock` function itself, the
VtabSync/loop `rc` handling, the `assert( rc!=SQLITE_BUSY )`) are left in
place; the function still exists and is used elsewhere (pager.c), and the
later `rc` check is now a harmless no-op. The lock is thus only obtained
later, in phase one, after the super-journal has been written.

## Oracle results

`test/tkt-f3e5abed55.test`: case 1.4 hits `Assertion 'rc!=SQLITE_BUSY' failed`
in vdbeCommit (the assert added by the fix, which guards exactly this case:
COMMIT of a two-file transaction while another connection holds a SHARED lock
now gets BUSY after the super-journal is written). The rest of the file
(1.5-2.5) fails as a result of the crash.
