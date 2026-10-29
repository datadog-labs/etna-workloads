repro.sql runs the aggnested-9.5 query: a triply nested correlated reference to an aggregate
(sum(a) AS x) from a GROUP BY subquery. Clean shell prints 6; buggy shell prints an empty
(NULL) row, exit 0. Cause: analyzeAggregate re-processes a TK_AGG_FUNCTION that already has
pAggInfo set (the `pExpr->pAggInfo==0` check removed by injection.patch).
(Combining all of 9.1-9.5 in one script triggers an assertion failure `pC!=0` in the buggy shell.)
