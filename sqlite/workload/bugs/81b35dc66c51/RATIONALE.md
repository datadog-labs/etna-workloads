# Rationale

Bug: 32-bit integer overflow of absolute segdir levels with large language ids (ext/fts3/fts3_write.c).

Most of the fix's `sqlite3_bind_int64` hunks are still present in 3.54.1, so I reverted two of them:

1. `getAbsoluteLevel()` (fix hunk 1): restored the pre-fix expression
   `(iLangid * p->nIndex + iIndex) * FTS3_SEGDIR_MAXLEVEL + iLevel`. It is computed in `int`, so it overflows
   for large langids, and the result is only widened to sqlite3_int64 on return. This removes the
   `sqlite3_int64 iBase` / cast.
2. `fts3WriteSegdir()` (fix hunk 5): restored `sqlite3_bind_int(pStmt, 1, iLevel)` for the level column
   (the parameter is already `sqlite3_int64`, so the value is truncated to 32 bits on insert).

Oracle cases failing (test/fts4langid.test, 8 of 308): 5.1.1, 5.1.2, 5.2.0, 5.2.1073741824, 5.3.2, 5.3.3, 5.3.5, 5.3.6.
With langid 1<<30, segdir levels are wrong (not 1<<40) and queries return wrong docids.
