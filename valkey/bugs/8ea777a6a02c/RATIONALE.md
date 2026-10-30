# Rationale

All changes are in `src/rdb.c`, `rdbLoadObject()`. They remove the empty-key
detection added by the fix (the `goto emptykey` paths), so a zero length (or an
empty converted ziplist) creates an empty key again instead of
`Bad data format` on RESTORE / silent skip on RDB load.

Removed (each reverses a `+ ... goto emptykey` hunk of fix.patch):
- `if (len == 0) goto emptykey;` after the length read for RDB_TYPE_LIST, RDB_TYPE_SET,
  RDB_TYPE_HASH, and RDB_TYPE_LIST_QUICKLIST(_2).
- `if (zsetlen == 0) goto emptykey;` for RDB_TYPE_ZSET/ZSET_2.
- `zsetLength(o) == 0` check in the RDB_TYPE_ZSET_ZIPLIST conversion.
- `hashTypeLength(o) == 0` check in the RDB_TYPE_HASH_ZIPLIST conversion.

The `error` out-parameter plumbing and the rdbLoadRio skip logic are kept, since
they are unreachable without the checks above and the other (listpack/intset/quicklist
post-load) empty checks, added later upstream, are left alone.

Failing oracle cases: "load corrupted rdb with empty keys" (dbsize is 4, not 0),
"empty intset", "empty hash ziplist", "empty zset", "hash with len of 0"
(RESTORE returns OK instead of `Bad data format`).
