# Rationale

Version 3.54.1 already contained the whole fix (all in ext/fts3/fts3_write.c), so I reverted each fix hunk by hand.

- `getAbsoluteLevel()`: this reverses the hunk that introduced `iBase`. It goes back to `(iLangid * p->nIndex + iIndex) * FTS3_SEGDIR_MAXLEVEL + iLevel`. That is computed in 32-bit `int` arithmetic, so it overflows for large language ids such as 1<<30.
- `sqlite3Fts3AllSegdirs()`, `fts3SegmentMaxLevel()` and `fts3DeleteSegdir()`: these reverse the hunks that changed `sqlite3_bind_int` to `sqlite3_bind_int64`. The binds are `sqlite3_bind_int` again, so the absolute level is truncated to 32 bits.
- `fts3SegmentMaxLevel()`: `*pnMax` is `int` again, and it is read with `sqlite3_column_int`.
- `fts3WriteSegdir()` and `fts3SegWriterFlush()`: the `iLevel` parameter is `int` again. `fts3WriteSegdir()` binds it with `sqlite3_bind_int`.
- `fts3SegmentMerge()`: `iNewLevel` and `iMaxLevel` are `int` again. `iMaxLevel` has to match the `int *` that `fts3SegmentMaxLevel()` takes now.

I did not revert the comment block above `getAbsoluteLevel()` or the "(relative level)" comment in the `sqlite3Fts3AllSegdirs()` signature.

## Oracle failures

`./check.sh` reports 8 of 308 oracle cases failing in test/fts4langid.test:

- 5.1.1: the `%_segdir` levels are wrong for language id 1<<30.
- 5.1.2, 5.2.0 and 5.2.1073741824: MATCH queries return the wrong docids.
- 5.3.2, 5.3.3, 5.3.5 and 5.3.6: the language-0 and large-language indexes get mixed together after the merge, for example 5.3.6 returns docids 1..21 instead of 2..21.
