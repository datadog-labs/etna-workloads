# Rationale

Fix hunk reversed: the `fts3SegReaderCursor()` call in `ext/fts3/fts3.c`, which
passed `(isPrefix==0 && isScan==0)` as the new `bLookup` argument of
`sqlite3Fts3SegReaderNew()`. It now passes `0`, so a segment reader is never
flagged as lookup-only. The other fix hunks (the `bLookup` field, the
`fts3SegReaderSetEof()` helper and its uses in `fts3SegReaderStart()` and
`sqlite3Fts3SegReaderStep()`) still exist in 3.54.1 but are never triggered.
Pre-fix, readers had no lookup mode, so this is the same behaviour.

The `bLookup` argument was the sole source of the flag in this path. (The
separate `Fts3MultiSegReader.bLookup` in fts3.c is a different, later field and
is untouched.)

## Oracle result
- `fts3prefix2-1.3` fails with "database disk image is malformed". A prefix
  query `T*` runs against a prefix index after deletes. This is what the fix's
  test guards against.
- `fts3auto` cases are unaffected (0 of 29 fail).
