# Rationale

## Changed hunk
`src/pager.c`, `pager_write_changecounter()`: the new counter is again computed from
the value currently in page 1's data at byte 24 (`sqlite3Get4byte(pPg->pData+24)+1`)
instead of from the pager's `dbFileVers` copy of the on-disk header.

This reverses the fix's only implementation hunk in `pager_incr_changecounter()`
(`retrieve32bits(pPgHdr,24)` -> `sqlite3Get4byte(pPager->dbFileVers)`). In 3.54.1 that
computation lives in `pager_write_changecounter()`. During VACUUM, page 1 is overwritten
with the content of the temp database, so its byte 24 holds the temp db's counter, not
the original file's; the counter then fails to advance past the original value (ticket #2518).

## Oracle failures
`vacuum2-2.1` and `vacuum2-2.2` (change counter after VACUUM is not original+1) fail.
