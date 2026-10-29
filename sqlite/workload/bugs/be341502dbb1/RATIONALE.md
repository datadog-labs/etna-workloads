# Rationale

Fix: the Bloom-filter optimization must not use IS NULL / IS NOT NULL
WHERE-clause constraints when operating on a LEFT JOIN. The fix made
`whereLoopOutputAdjust()` skip marking WHERE_SELFCULL for such terms.

## Changes (tree/src/where.c)

1. `whereLoopOutputAdjust()`: removed the 2022-03-24 guard, restoring the
   unconditional `pLoop->wsFlags |= WHERE_SELFCULL;`. This reverses the fix hunk
   exactly (modern code also tests JT_LTORJ). Alone, this does not fail the
   oracle, because later code covers the case in another path:
2. `whereLoopInitBloomFilter()` (Bloom-filter build loop): newer code only
   admits terms accepted by `sqlite3ExprIsSingleTableConstraint()`, which
   rejects WHERE-clause (non-ON) terms on a LEFT JOIN table (rule 4a). I
   re-admit such terms (LEFT but not LTORJ, not EP_OuterON, single-table
   constant) in this loop only. This is the same defect: the filter is
   populated using WHERE-clause terms such as `d IS NULL` on the LEFT JOIN
   table, so it drops the rows needed to produce NULL-extended results.

## Oracle failure
join5-11.2 (`SELECT count(*) FROM t1 LEFT JOIN t2 ON c=b WHERE d IS NULL`)
returns 8 instead of 4.
