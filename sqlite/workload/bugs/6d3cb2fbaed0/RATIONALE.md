# Rationale

Fix: in `sqlite3Fts3Offsets()` the tokenizer's SQLITE_DONE (a column with zero
tokens, or fewer tokens than the position list implies) was treated as
corruption after the loop. The fix made the post-loop DONE mean OK and moved
CORRUPT into the loop (`else if( rc==SQLITE_DONE )`).

Changes in `ext/fts3/fts3_snippet.c` (`sqlite3Fts3Offsets`):
1. Removed the `else if( rc==SQLITE_DONE && pTab->zContentTbl==0 ) rc = FTS_CORRUPT_VTAB;`
   branch (reverses fix hunk 1).
2. Post-loop `if( rc==SQLITE_DONE )` now sets `FTS_CORRUPT_VTAB` instead of
   `SQLITE_OK` (reverses fix hunk 2). So an xNext DONE, including the very
   first xNext on an empty string, is reported as corruption.
3. The "all offsets gathered" case set `rc = SQLITE_DONE` to end the loop; with
   (2) that would make every normal call fail, so it is now `break` (rc stays
   SQLITE_OK). This keeps the normal exit path as it was before the fix.

Oracle failures: fts3ac-6.1 and fts3ac-6.2 fail with
"database disk image is malformed" (an empty column value makes offsets() error).
