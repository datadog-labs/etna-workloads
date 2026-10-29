repro.sql replays fts4onepass-4.0: two UPDATEs of the same FTS4 row (rowid 1) in one transaction, then counts zt_segdir rows.
Clean: prints 3. Buggy: aborts (exit -6) on assertion in fts3PendingListAppend, because the injected bug skips fts3PendingTermsDocid on the second update, so both updates share one segment.
