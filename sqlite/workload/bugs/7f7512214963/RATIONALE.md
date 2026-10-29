# Rationale

The fix (ticket #3731) moved the OP_NewRowid next-rowid cache from VdbeCursor
into BtCursor, shared by all cursors on the same table. 3.54.1 has no cache at
all (OP_NewRowid always calls sqlite3BtreeLast), so I restored the pre-fix
per-VdbeCursor cache, which is the bug: two VdbeCursors on one table (e.g. a
trigger inserting into its own table) each keep a private cache and hand out
the same rowid.

Changes (reverse of fix hunks):
- src/vdbeInt.h: re-add `nextRowid` and `nextRowidValid` to VdbeCursor (fix hunk
  removing them). Placed in the zero-initialised prefix of the struct.
- src/vdbe.c OP_NewRowid: use `nextRowid` if valid, else BtreeLast; after
  choosing v, set the cache to v+1 (or invalid at MAX_ROWID). Reverses the
  hunks replacing this with sqlite3BtreeGet/SetCachedRowid. The cache update is
  skipped in the random-rowid case, which the old code never cached either.
- src/vdbe.c OP_Insert: re-add invalidation when inserted key >= nextRowid
  (removed hunk).
- src/vdbe.c OP_Delete: re-add `pC->nextRowidValid = 0` after the delete
  (removed hunk).
The BtCursor-side hunks (cachedRowid, Get/SetCachedRowid) are not present in
3.54.1 and are simply not applied.

Oracle: test/tkt3731.test tkt3731-1.3 fails (the outer INSERT..SELECT cursor
reuses a cached rowid already taken by the trigger's cursor, so rows are
overwritten: got `e f g h g+ h+`), and tkt3731-1.4 fails with
"wrong # of entries in index sqlite_autoindex_t1_1".
