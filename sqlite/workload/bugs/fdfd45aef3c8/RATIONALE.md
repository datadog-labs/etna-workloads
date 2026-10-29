# Rationale

Both changes are in `constInsert()` in `tree/src/select.c` and reverse the two
implementation hunks of the fix (ticket 1dcb4d44964846ad).

1. Hunk 1: the fix replaced
   `if( !EP_FixedCol(pValue) && affinity(pValue)!=0 ) return;` with
   `if( EP_FixedCol(pColumn) ) return; if( affinity(pValue)!=0 ) return;`.
   I restored the pre-fix test, which looks at EP_FixedCol on the VALUE
   instead of the COLUMN. 3.54.1 already had the fixed form, so this is a
   direct restoration of the old condition.
2. Hunk 2: the fix removed `if( EP_FixedCol(pValue) ) pValue = pValue->pLeft;`
   before the apExpr entries are stored. I put it back.

Effect: a column marked EP_FixedCol is no longer excluded from constant
propagation, and a FixedCol value is substituted by its inner expression.
That produces wrong propagation.

Failing oracle cases: whereL-600 returns `good good bad good` instead of
`good good`. whereL-610 returns extra rows. Both are wrong query results.
