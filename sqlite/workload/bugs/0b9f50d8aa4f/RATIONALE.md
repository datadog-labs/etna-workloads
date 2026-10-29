# Ticket #3928 re-injection (autoincrement + triggers)

The fix introduced `AutoincInfo` (one per table per statement, shared by all
inserts including those in triggers) plus deferred `sqlite3AutoincrementBegin/End`.
In 3.54.1 that machinery still exists (`autoIncBegin()` in src/insert.c), so only
the sharing was reverted.

## Changed hunk
`src/insert.c`, `autoIncBegin()`: the lookup loop
`while( pInfo && pInfo->pTab!=pTab ){ pInfo = pInfo->pNext; }` is replaced by
`pInfo = 0;`. This reverses the fix hunk "There is at most one AutoincInfo
structure per table even if the same table is autoincremented multiple times
due to inserts within triggers". Pre-fix, every INSERT got its own counter
registers and its own sqlite_sequence slot; now each INSERT (including each
trigger INSERT) again allocates a fresh AutoincInfo, so they load the same
starting counter and write back separately, creating extra sqlite_sequence rows.

## Oracle failures (test/autoinc.test)
autoinc-3928.2, .3, .4, .5, .7: duplicate ids/wrong values from triggers, and
sqlite_sequence gets several rows per table (e.g. `t3928 20 t3928 13 ...`
instead of `t3928 21 t3928c 6`).
