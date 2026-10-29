Reproducer: repro.sql (test indexexpr2-9.0). An outer query uses an index on an expression (abs(b)), and a correlated reference to that expression appears inside an aggregate in a scalar subquery.

Clean shell: returns `5|-5|205` and `5|20|220`, exit 0.
Buggy shell: assertion failure in aggregateIdxEprRefToColCallback (`pExpr->iAgg<pAggInfo->nColumn`), abort, exit 134.
