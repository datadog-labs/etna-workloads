# Rationale

Fix (ticket #2286): in sqlite3BtreePrevious(), the skip check (`skip<0` -> return OK, res=0)
ran *before* the `CURSOR_INVALID` check, so a cursor whose table was deleted out from under
it was reported as still positioned instead of finished. The fix moved the INVALID check first.
(The sqlite3BtreeNext hunk is the same reordering for Next; Next's modern code was not changed.)

## Change: tree/src/btree.c, btreePrevious()
In 3.54.1 the logic is in btreePrevious() after restoreCursorPosition(). The INVALID check
(return SQLITE_DONE) came first, then the SKIPNEXT check. I restored the pre-fix order:
SKIPNEXT check first, then the INVALID check, which now returns SQLITE_OK when
`skipNext<0` (the old "skip<0 -> res=0" short circuit taking precedence over INVALID).
This reverses the Previous hunk's reordering.

## Oracle failures (test/misc2.test)
- misc2-7.12: reverse-order SELECT with DELETE of the rows inside the loop; the cursor
  continues past the end of the deleted table -> "incomplete input" error instead of `0 {}`.
- misc2-7.16: reverse SELECT with `DELETE FROM t1` in loop; the loop yields an empty row
  -> `can't use empty string as operand of "&"`.
