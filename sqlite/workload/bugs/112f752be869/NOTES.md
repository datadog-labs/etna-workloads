repro.sh: connection A (kept open via coproc) loads pages into its cache. Connection B commits a
large update, then starts a second transaction with a tiny cache (so the journal is synced and the
database is partially overwritten) and is killed with SIGKILL, leaving a hot journal. When A next
reads, it rolls back the hot journal.

Clean: the pager cache is reset before playback; integrity_check prints `ok`, count is 6.
Buggy (needPagerReset=0): the cache is not purged, so A aborts with the assertion
`pPager->eState!=PAGER_OPEN || pPg==0 || pPager->tempFile' in pager_playback_one_page
(otherwise it would see a stale/inconsistent cache).
