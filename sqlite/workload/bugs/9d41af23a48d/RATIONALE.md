# Rationale

Bug: NATURAL JOIN treated HIDDEN columns (e.g. the FTS5 `rank` / table-name column) as join columns.

Changes, all in `tree/src/select.c`, `sqlite3ProcessJoin()` NATURAL branch:

1. Removed `if( IsHiddenColumn(&pRightTab->aCol[j]) ) continue;`. This reverses the fix hunk that added that line in the NATURAL loop.
2. Passed `bIgnoreHidden=0` instead of `1` to `tableAndColumnIndex()` in that loop. This reverses the fix hunk that changed the call from 0 to 1 (the hunk added the argument).

The fix's third use of the flag was in `selectExpander`. In 3.54.1 that code no longer calls `tableAndColumnIndex`; NATURAL joins are converted to USING lists in `sqlite3ProcessJoin`, so the two changes above cover it. The USING branch already passes 0 and is unchanged.

Oracle: `fts5misc-12.1` and `fts5misc-12.2` fail (NATURAL JOIN of `t1(a,b,rank)` with fts5 table `ft` wrongly joins on the hidden `rank` column, giving wrong results). Other cases pass.
