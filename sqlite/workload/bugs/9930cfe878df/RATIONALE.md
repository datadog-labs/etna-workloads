# Rationale

## ext/fts3/fts3_write.c, sqlite3Fts3SegReaderStep()
Reverses the single implementation hunk of the fix. The fix replaced the
post-hoc check `iDelta<=0 && (nDoclist>0 || iDelta!=iDocid)` (plus the
`assert( nDoclist>0 || iDelta==iDocid )`) with direct comparisons of
iPrev/iDocid. 3.54.1 already had the direct comparisons (with u64 wraparound
arithmetic for iDelta); I restored the old signed-delta check instead. When two
consecutive rowids differ by more than 2^63, the wrapped iDelta is negative, so
a valid doclist is reported as corrupt.

## Oracle failure
fts3misc-9.1 (integrity-check on rowids -4764623217061966105 and
8324454597464624651) fails with "database disk image is malformed".
