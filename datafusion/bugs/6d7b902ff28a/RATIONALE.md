# Rationale

Fix hunk reversed: in `pushdown_requirement_to_children`, the
`else if let Some(hash_join) = plan.as_any().downcast_ref::<HashJoinExec>() { handle_hash_join(...) }`
branch. In 55.2.0 it lives in
`datafusion/physical-optimizer/src/ensure_requirements/enforce_sorting/sort_pushdown.rs`.
I removed the branch, so `HashJoinExec` falls through to `handle_custom_pushdown`, as it did before the fix.
That path pushes the parent's sort requirement to the right child without remapping column indices
through the join's output schema, and without checking that the columns come from the right side.
`handle_hash_join` and `build_join_column_index` are left in place but unused.

Oracle: `joins.slt` fails. The hash-join sort pushdown query from the fix
(`select * from test where a in (select a from test where b > 3) order by c desc ...`)
now gives a different physical plan from the expected one.
The sort is no longer pushed below `HashJoinExec` correctly, and the test_files also show other plan diffs (2 failures in total).
