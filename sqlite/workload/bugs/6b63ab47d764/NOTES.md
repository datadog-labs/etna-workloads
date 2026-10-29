Reproducer (repro.sh) mirrors pager1-20.2.*: in exclusive locking mode with
journal_mode=persist, run `BEGIN EXCLUSIVE; COMMIT;` with no changes.
Clean shell finishes normally (exit 0). Buggy shell aborts (exit 134) on the
assert `pPager->journalOff==JOURNAL_HDR_SZ(pPager)` in sqlite3PagerCommitPhaseTwo,
since journalOff can legitimately be 0 there.
