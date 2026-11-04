# Rationale

File: `datafusion/physical-optimizer/src/ensure_requirements/enforce_sorting/sort_pushdown.rs`
(the file moved from `enforce_sorting/` since the fix).

Changes (all reverse the fix's hunks):
1. Removed the `else if let Some(aggregate_exec) = plan.downcast_ref::<AggregateExec>() { handle_aggregate_pushdown(...) }`
   dispatch branch in `pushdown_requirement_to_children` (fix hunk 2). Aggregates again fall into the generic
   `maintains_input_order` / `handle_custom_pushdown` path, which pushes the parent requirement (expressed in
   the aggregate's output schema) to the input unchanged and never checks that it is a group-by column or
   that the input ordering satisfies it.
2. Removed `handle_aggregate_pushdown` (fix hunk 3), now unused.
3. Removed the `AggregateExec` import (fix hunk 1).

## Oracle
`sort_pushdown.slt` fails (Test 3.7): the SortExec above `AggregateExec` with
`ORDER BY x, CAST(y AS BIGINT) % 2` is wrongly removed, so the EXPLAIN plan differs and the query returns
wrongly ordered rows (`1 1 40` before `1 0 20`).
