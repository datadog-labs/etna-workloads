# Rationale

## Changed hunk
`datafusion/physical-plan/src/aggregates/mod.rs`, `AggregateExec::execute_typed`:
`self.group_by.is_true_no_grouping()` -> `self.group_by.expr.is_empty()`.

Reverses the fix hunk that replaced `self.group_by.expr.is_empty()` ("no group by at all")
with `is_true_no_grouping()`. The rest of the fix (`has_grouping_set` flag, schema logic,
`from_pre_group`/`as_final`) is already in 55.2.0 and left untouched. With the old condition,
`GROUPING SETS(())` (empty exprs, `has_grouping_set = true`) is routed to the no-grouping
`AggregateStream`, which doesn't emit the `__grouping_id` column that the schema contains.

## Oracle failures
`grouping.slt`: `GROUP BY GROUPING SETS(())` queries fail with
"Arrow error: Invalid argument error: number of columns(N) must match number of fields(N+1) in schema".
