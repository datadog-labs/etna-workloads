# Rationale

## Hunk changed: src/where.c, whereLoopAddVirtual-side constraint collection (the loop that sets TERM_OK before allocateIndexInfo)

Fix hunk reversed: the fix added a check in `allocateIndexInfo()` that skips
`IS` / `IS NULL` WHERE terms (not EP_FromJoin, now EP_OuterON/InnerON) when the
virtual table is the rhs of a LEFT JOIN. In 3.54.1 that filtering is done
by `constraintCompatibleWithOuterJoin()`, called from the same constraint-gathering
loop, which rejects terms that are not ON-clause terms of this join. I
exempt `WO_IS|WO_ISNULL` terms from that call, so a WHERE-clause
`vtab.col IS NULL` is again offered to xBestIndex on a LEFT JOIN rhs
and the vtab may mark it omit, as before the fix.

## Oracle failures (test/bestindex6.test)
- 1.2: returns an extra row `1 1 good {} {}` (the IS NULL is consumed by the vtab
  before the LEFT JOIN null-row is generated).
- 1.3: error `near "%": syntax error` (the `IS $xxx` term is passed with a NULL arg, mishandled).
