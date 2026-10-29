# Rationale

Fix hunk reversed: in `disableUnusedSubqueryResultColumns()` the fix added an
`if( pSub->selFlags & SF_Distinct ) return 0;` guard. In 3.54.1 that check was
folded into the loop over compound elements, `(pX->selFlags & (SF_Distinct|SF_Aggregate))`.
I removed `SF_Distinct` from that mask (src/select.c), so DISTINCT subqueries
(and views) again get their unused columns NULLed out, which changes what
DISTINCT deduplicates. The `TF_Ephemeral` reformatting hunk is cosmetic.

Failing oracle cases (test/selectC.test): selectC-4.2 (got `1`, expected `1 1 1`),
selectC-4.2b (same, via a view), selectC-4.3 (got `1 1`, expected `1 1 1 2 1 3`).
