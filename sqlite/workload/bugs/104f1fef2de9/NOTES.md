`repro.sh` creates a file database with an FTS3 table and inserts one row. FTS3 runs
internal statements during the insert, so a commit happens while another statement
is still active. The pager then drops only to SHARED_LOCK.

With the bug, `pagerUnlockDb(SHARED_LOCK)` no longer clears `changeCountDone`. That
leaves `changeCountDone` set without a RESERVED lock, and a later commit could skip
the change-counter update (lock-6.x). The clean shell prints `1` and exits 0. The
buggy shell aborts on the debug assertion `pPager->changeCountDone==0 ||
pPager->eLock>=RESERVED_LOCK` in `assert_pager_state` (exit 134).

I did not reproduce the stale-cache symptom itself, where a second connection
misses the change. The assertion fires first. The reproducer needs a file database
because `:memory:` has no such lock handling.
