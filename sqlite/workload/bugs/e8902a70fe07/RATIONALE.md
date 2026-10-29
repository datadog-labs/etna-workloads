# Rationale

## Change
`tree/src/select.c`, `flattenSubquery()`: removed the
`if( pSub->pOrderBy ){ return 0; /* Restriction (20) */ }` check inside
`if( pSub->pPrior ){ ... }`.

This reverses the single implementation hunk of the fix, which added exactly
that check (restriction 20: a compound subquery with ORDER BY must not be
flattened). The check still exists at the same spot in 3.54.1, so the
reversal is direct. The restriction-20 comment in the header is left as is.

## Oracle
- `tkt3773-1.1` fails: the subquery is flattened despite its ORDER BY, and
  testfixture hits the assertion
  `multiSelectByMerge: Assertion 'pItem->u.x.iOrderByCol>0' failed`.
  Without the assert it would return the wrong result.
- The selectB cases, which the fix commented out, don't fail on this build.
