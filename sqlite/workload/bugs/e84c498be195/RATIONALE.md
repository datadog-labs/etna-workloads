# Rationale

Fix hunk (ext/fts3/fts3_write.c, sqlite3Fts3UpdateMethod): changed
`if( rc==SQLITE_OK && (!isRemove || *pRowid!=p->iPrevDocid ) )` to `if( rc==SQLITE_OK )`
before calling fts3PendingTermsDocid().

Reversal in 3.54.1: the `isRemove` variable no longer exists, so I re-added it
(`int isRemove`, set to 1 just before the fts3DeleteByRowid() call for the old record)
and restored the pre-fix condition on the fts3PendingTermsDocid() call. When an UPDATE
hits the same rowid as the previous op in the transaction, the pending-terms flush is
skipped, so both versions of the row land in the same segment.

Failing oracle case: fts4onepass-4.0 (two UPDATEs of rowid 1 in one transaction)
aborts with assertion `iPos>p->iLastPos ...` in fts3PendingListAppend; without
asserts it would yield the wrong segdir count (expected 3).
