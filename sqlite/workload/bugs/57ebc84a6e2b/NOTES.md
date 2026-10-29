repro.sql creates an fts4 table, then in one transaction inserts a row and runs
'optimize' while no segments exist on disk.

Clean: the pending row is flushed. fts_segdir has `0|0`, MATCH finds rowid 2,
and integrity-check passes (exit 0).
Buggy: the in-memory data is discarded. fts_segdir is empty, MATCH returns
nothing, and integrity-check fails with "database disk image is malformed" (exit 1).
