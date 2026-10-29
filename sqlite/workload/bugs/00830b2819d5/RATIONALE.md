# Rationale

Only file changed: `ext/fts3/fts3_write.c`, in `fts3ChecksumIndex()`. This reverts the single implementation hunk of fix.patch. Today's code was already partly different from the fix's pre-image (the loop was already restructured and had an `iPos>0x7FFFFFFF` check), so I restored the pre-fix semantics by hand:

- Removed the `iPos` range check that sets `rc = SQLITE_CORRUPT_VTAB`. The checksum is computed unconditionally, as before the fix, so a corrupt position is no longer reported.
- `iCol` is `i64` again and is read with `sqlite3Fts3GetVarint()`. The fix changed it to `int` read with `fts3GetVarint32`. With `i64` the value is silently truncated by the `(int)iCol` cast.
- Removed the `rc = SQLITE_OK;` reset at the top of the per-row body. It only existed to support the new `break`.

## Oracle
`fts3corrupt7-9.1` fails. The corrupt database from test 9.0 no longer produces "malformed inverted index for FTS3 table main.t". check.sh reports the run as incomplete (crash, assert or timeout) at that case. The other 15 cases pass.
