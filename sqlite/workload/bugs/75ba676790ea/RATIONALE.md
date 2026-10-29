# Rationale

## Change: tree/src/vacuum.c, sqlite3RunVacuum()
The fix changed `sqlite3BtreeSetPagerFlags(pTemp, PAGER_SYNCHRONOUS_OFF)` to
`PAGER_SYNCHRONOUS_OFF|PAGER_CACHESPILL`, so the temp database could spill
its cache to a temp file instead of being built wholly in heap memory.
In 3.54.1 the call is `sqlite3BtreeSetPagerFlags(pTemp, pgflags|PAGER_CACHESPILL)`
(pgflags defaults to PAGER_SYNCHRONOUS_OFF; VACUUM INTO overrides it). I removed
`|PAGER_CACHESPILL`, which restores the pre-fix flags for plain VACUUM:
cache spill is disabled (SPILLFLAG_OFF set in sqlite3PagerSetFlags), so the new
image stays in memory. (VACUUM INTO's stale "always set" comment is left as is.)

## Oracle failure
vacuum5-3.2 fails: expected open list `test.db test.db-journal test.db-journal {} test.db-journal`
(a temp file is opened during VACUUM), got `test.db test.db-journal test.db-journal test.db-journal`
(no temp file opened).
