# Rationale

Fix 6749cb3c split `nIdxCol` (set on every ORDER BY match) into `nDistinctCol`
(set only under WHERE_DISTINCTBY). In 3.54.1 the field is already named
`nDistinctCol`; I reverted both `src/where.c` hunks in `wherePathSatisfiesOrderBy()`:

1. Reset `pLoop->u.btree.nDistinctCol = 0` for every non-virtual loop again,
   not only when `wctrlFlags & WHERE_DISTINCTBY` (reverses hunk 1).
2. Set `nDistinctCol = j+1` on every ORDER BY column match, without the
   `WHERE_DISTINCTBY` check (reverses hunk 2).

So the ORDER BY column count is confused with the DISTINCT column count, and
the stat1-driven `OP_SeekLE`-style skip in `sqlite3WhereEnd()` (hunk 3's consumer,
`n = nDistinctCol`) uses too few columns. The field rename and header hunk are cosmetic and left as is.

Failing oracle cases: distinct2-2020 and distinct2-2040 (wrong DISTINCT rows after ANALYZE).
