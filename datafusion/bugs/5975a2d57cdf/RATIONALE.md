# Rationale

The fix's implementation hunk was in `HashJoinExec::allow_join_dynamic_filter_pushdown`
(`datafusion/physical-plan/src/joins/hash_join/exec.rs`). It added an early
`return false` when `self.null_aware` and any build key is nullable. 55.2.0
still has this guard at the same place, so the hunk reverses cleanly.

## Change
Removed the guard block from `allow_join_dynamic_filter_pushdown`. This is
exactly the fix's added hunk reversed. With the guard gone, a null-aware
LeftAnti join with a nullable build key pushes its bounds/membership dynamic
filter onto the probe scan again. The filter can prune every probe row, and the
join then treats the probe as empty and emits the build-side NULL row.

## Oracle failures
- `push_down_filter_parquet.slt`: `SELECT id FROM ao_p WHERE id NOT IN (SELECT eid FROM i_disj_p)`
  returns `5, NULL` instead of `5`.
- `explain_tree.slt`: the probe `DataSourceExec` shows `predicate: DynamicFilter [ empty ]` again.
- `dynamic_filter_pushdown_config.slt`: the plans show the `DynamicFilter` predicate on the null-aware
  anti join probe scans again.
