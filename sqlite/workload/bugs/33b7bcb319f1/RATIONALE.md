# Rationale

Fix hunk (ext/fts3/fts3_write.c, fts3IntegrityCheck): wrapped the per-column
tokenize/checksum loop body in `if( p->abNotindexed[iCol]==0 )`, so notindexed
columns are skipped when computing the expected checksum.

Change: in 3.54.1 (tree/ext/fts3/fts3_write.c, fts3IntegrityCheck, ~line 5371)
the guard `if( p->abNotindexed[iCol]==0 ){` is replaced by a bare `{` block.
Notindexed columns are therefore tokenized and checksummed even though they
are not in the index, as before the fix.

Oracle: fts4check-4.0 fails with "database disk image is malformed" — the
integrity-check on a table with notindexed=b reports corruption on a healthy table.
