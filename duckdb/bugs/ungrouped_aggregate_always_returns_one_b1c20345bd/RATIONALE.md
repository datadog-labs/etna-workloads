# Rationale

Hunk: src/optimizer/statistics/operator/propagate_aggregate.cpp, `StatisticsPropagator::PropagateStatistics(LogicalAggregate&)`.
Traces to the fix's only hunk (the `if (aggr.groups.empty()) return NodeStatistics(1,1)` block; in v2.0.0 it was spelled with a local `is_ungrouped`).
I removed that early return (and the now-unused `is_ungrouped` local, to keep the build warning-free). An ungrouped aggregate again inherits its child's cardinality (0 rows for an empty table), so COUNT(*)+LIMIT 1 is treated as max 0 rows, LIMIT is dropped and the EXISTS rewrite folds to false.

Oracle result:
```
FAIL     test/sql/subquery/exists/test_issue_26401.test
         test/sql/subquery/exists/test_issue_26401.test:15
         SELECT EXISTS (SELECT 1 FROM t WHERE NOT EXISTS (SELECT 1 FROM e));
         Expected 1, actual 0
1 of 1 oracle units fail
```
