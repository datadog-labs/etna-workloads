# Rationale

## Change: src/select.c, flattenSubquery()
Fix hunk reversed: the replacement of
`if( ((pSub->selFlags & SF_Distinct)!=0 || pSub->pLimit) && (pSrc->nSrc>1 || isAgg) ) return 0;`
with a separate unconditional `if( pSub->selFlags & SF_Distinct ) return 0;`.
In 3.54.1 the unconditional DISTINCT check (restriction 4) is already split from the LIMIT check
(restrictions 8/9), so I restored the old condition for the DISTINCT part only:
`SF_Distinct && (pSrc->nSrc>1 || isAgg)`. A DISTINCT sub-query is therefore flattened again when
the outer query is a single-table, non-aggregate query. The LIMIT line is unchanged.
The comment-only hunks of the fix were not reverted.

## Oracle failures
test/selectC.test: selectC-4.2 (and the cases after it, 4.2b, 4.3, 5.x) fail. `select a from (select distinct a, b ...)`
flattens the DISTINCT sub-query, which trips the assertion `(pSub->selFlags & SF_Distinct)==0`
in flattenSubquery (restriction 17b path), so the run aborts. In a non-assert build the result would be
the wrong row count (the DISTINCT is dropped, as in selectC-4.2/4.3).
