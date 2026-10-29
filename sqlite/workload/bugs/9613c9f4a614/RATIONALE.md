# Rationale

Fix hunk (ext/fts3/fts3_write.c, fts3ChecksumIndex): the fix made the docid-delta
decoding subtract the delta when `p->bDescIdx` is set (ORDER=DESC tables).

In 3.54.1 the same code exists (using `sqlite3Fts3GetVarintU` and u64 casts). I
removed the `if( p->bDescIdx )` branch so the delta is always added:
`iDocid = (i64)((u64)iDocid + iVal);`. This is the pre-fix behaviour, so the
integrity-check checksum computes wrong docids for DESC tables.

Oracle failure: fts3misc-7.0.2 (integrity-check on an `order=DESC` fts4 table with
two rows) fails with a checksum mismatch / corrupt-vtab error.
