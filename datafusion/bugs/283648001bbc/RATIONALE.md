# Rationale

Fix: skip `try_pushdown_through_join` for LeftMark/RightMark in `HashJoinExec` and
`NestedLoopJoinExec::try_swapping_with_projection`. In 55.2.0 the guard is
implicit: both call `try_pushdown_through_join_with_column_indices`, which declines
on `JoinSide::None` (the synthetic mark column). Reversing the fix hunks does not apply.

## Changes
- `joins/hash_join/exec.rs` and `joins/nested_loop_join.rs`: call the older
  `try_pushdown_through_join` (still in `projection.rs`) instead of the
  `_with_column_indices` variant. It splits columns positionally (`left ++ right`),
  as the fix's pre-state did. This reintroduces the mark-join misrouting. The
  import and call are the only edits (the `column_indices` argument is dropped).

## Oracle
`subquery.slt` fails: queries with a mark join such as
`SELECT t1_name FROM t1 WHERE t1_id > 40 OR EXISTS (...)` error with
`ProjectionPushdown ... Internal error: Assertion failed: col.name() == matching_name`,
the same error as issue #22901.
