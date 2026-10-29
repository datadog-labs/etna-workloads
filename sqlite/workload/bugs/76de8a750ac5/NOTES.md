Creates a zero-length database with a bogus 1-byte `test.db-journal` (an apparently hot journal), then runs `PRAGMA locking_mode=EXCLUSIVE; SELECT * FROM sqlite_master;` (exclusive-6.5).

Clean shell prints `exclusive` and exits normally. Buggy shell hits the assertion `!pPager->exclusiveMode || pPager->eLock==eLock` in pagerUnlockDb (called from hasHotJournal) and aborts (exit 134).
