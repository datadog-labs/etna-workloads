Reproducer (repro.sql): the skipscan1-5.0 case, with page_size=1024 so the 482-char key overflows a page.
`SELECT max(a) FROM t1 WHERE a IN t1` uses OP_SeekScan; without the fix it steps the cursor
with sqlite3BtreeNext but doesn't set `pC->cacheStatus = CACHE_STALE`, so a stale cached row is used.
Clean shell prints `3`; buggy shell aborts with assertion `offset+amt <= pCur->info.nPayload` in accessPayload (exit -6).
