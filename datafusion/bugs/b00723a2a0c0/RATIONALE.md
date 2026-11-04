# Rationale

File: `datafusion/physical-optimizer/src/ensure_requirements/enforce_sorting/sort_pushdown.rs`

Fix hunk reversed: in `pushdown_requirement_to_children`, the fix removed
`|| plan.as_any().is::<HashJoinExec>()` from the list of plans that never get
sort requirements pushed down, and routed other plans to `handle_custom_pushdown`.
In 55.2.0 the same logic lives in the `else if maintains_input_order.is_empty() || ...`
branch, which comes before the `HashJoinExec` branch (`handle_hash_join`, the
descendant of the fix's custom pushdown for hash joins). I re-added
`|| plan.is::<HashJoinExec>()` to that condition, so hash joins again decline
pushdown and `handle_hash_join` is unreachable. NestedLoopJoin still uses
`handle_custom_pushdown`, as the fix's first test covers.

Oracle: `joins.slt` second EXPLAIN (HashJoinExec with filter, ORDER BY x) fails.
The SortExec stays above the HashJoinExec (`SortExec: expr=[x@3 ...]`) instead of
being pushed to the right child.
