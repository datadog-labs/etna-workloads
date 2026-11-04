# Rationale

## Changed hunk
`datafusion/core/src/physical_planner.rs`, `handle_explain`: the `Err` arm of
`create_initial_plan` now pushes `StringifiedPlan::new(InitialPhysicalPlan, e.to_string())`
instead of `PhysicalPlanError` + `err.strip_backtrace()`.

This reverses the `physical_planner.rs` hunk of the fix. The `PhysicalPlanError`
plan type still exists (its `should_display` hunk is kept), but the planner no
longer uses it. `InitialPhysicalPlan` is only displayed in verbose mode, so a
non-verbose `EXPLAIN` of a plan that fails physical planning silently drops the
error. The text also carries the backtrace again, since `strip_backtrace` is not used.

## Failing oracle cases
- `explain.slt`, `group_by.slt`, `joins.slt`, `update.slt`: expected
  `physical_plan_error ...` rows are missing from the output (e.g. EXPLAIN of an
  UPDATE with a scalar subquery, or of a lateral join with an outer reference).
- `prepare.slt` was not reported failing.
