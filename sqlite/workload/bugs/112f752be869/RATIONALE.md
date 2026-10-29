# Rationale

Fix 6143 has two implementation hunks in pager.c (plus the journalHdrOffset refactor, which already exists and is not needed).

1. `pagerSharedLock`: the fix added `sqlite3PcacheClear()` before `pager_playback(pPager, 1)` of a hot journal. In 3.54.1 this is `needPagerReset = isHot` in `pager_playback()`, which calls `pager_reset()` before the first page is rolled back. Changed to `needPagerReset = 0`, so a stale page cache survives the hot-journal rollback (corruption scenario 1).
2. `syncJournal`: the fix added a read of 8 bytes at the next header offset and a zero-byte write if it matches `aJournalMagic`. Removed that block (the `iNextHdrOffset`/`aMagic` read/write) in `syncJournal` (scenario 2). No oracle case fails from this alone; the crash timing in crash8.2.1 does not hit it.

Oracle: with both changes, crash8-1.3 trips the assertion `pPager->eState!=PAGER_OPEN || pPg==0 || pPager->tempFile` in `pager_playback_one_page` (stale cache), aborting the run, so 43 of 45 cases fail (crash8-1.3 onward).
