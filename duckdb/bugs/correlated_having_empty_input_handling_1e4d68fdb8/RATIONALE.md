# Rationale
All changes in src/src/planner/subquery/flatten_dependent_join.cpp (reverting the fix's hunks there):
- PushDownProjection: removed the ExpressionBecomesNull/CanThrow analysis; back to `propagate_null_values &= expr->PropagatesNullValues()` for each expression (fix hunk "PushDownProjection"). Helper `ExpressionCanThrowOnNullInput` removed (it became unused).
- PushDownAggregate (expressions loop): back to `expr->PropagatesNullValues()` without the volatile check.
- PushDownAggregate (join type): restored the old INNER/LEFT selection loop over aggregate expressions.
- PushDownCorrelatedNodeInternal: LOGICAL_FILTER shares the case with LOGICAL_UNNEST again, no volatile/CanThrow check.
The shared ExpressionBecomesNull helper in other files is left untouched (still used elsewhere).

Result: a correlated HAVING with empty input yields wrong results (INNER join drops outer rows).
etna-check:
FAIL test/sql/subquery/scalar/test_correlated_having.test:17 Wrong result in query! ... Mismatch on row 2
1 of 1 oracle units fail
