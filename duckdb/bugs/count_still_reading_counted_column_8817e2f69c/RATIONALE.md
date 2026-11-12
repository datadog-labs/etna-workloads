# Rationale

Today's code has evolved: the COUNT(x)->COUNT(*) rewrite now lives in the count statistics callback, and the
flag is called `removed_expressions` (not `removed_aggregate_children`). The re-pruning in optimizer.cpp is gated on it.

## Hunk
`src/optimizer/statistics/expression/propagate_aggregate.cpp`, `StatisticsPropagator::PropagateExpression(BoundAggregateExpression&, ...)`:
removed the `child_count` capture and the `removed_expressions |= aggr.GetChildren().size() < child_count;` line.
Traces to the fix's hunk of the same file (which added the flag update after the statistics callback).
Without it, when the callback drops the aggregate's children (COUNT(x) -> COUNT(*)), the propagator doesn't report it, so
the second UNUSED_COLUMNS pass is skipped (when nothing else was removed) and the counted column stays in the scan.

## Oracle results
```
FAIL     test/optimizer/statistics/statistics_count_not_null_join_pruning.test
FAIL     test/optimizer/statistics/statistics_count_not_null_pruning.test
2 of 2 oracle units fail
```
