# Rationale

Fix: #13388 changed `can_hash` (datafusion/expr/src/utils.rs) to match what `create_hashes` supports at run-time.

The `hash_utils.rs` hunk only removed dead Decimal arms from `create_hashes`; it does not change behaviour, so it is not reverted.

## Changes (all in `can_hash`, `datafusion/expr/src/utils.rs`)

- Fix hunk: added `Binary`, `LargeBinary`, `BinaryView => true`.
  Reverted: these now return `false` again (grouped with the unsupported types). Equi-joins on binary columns are no longer planned as hash joins.
- Fix hunk: `List/LargeList/FixedSizeList` changed from `=> true` to `can_hash(value_type.data_type())`.
  Reverted: they are unconditionally `true` again, so lists of unhashable element types (e.g. a union) are considered hashable and a hash join is planned on them, which fails at run-time.

The pre-fix `Map` arm and the narrower Dictionary arm were left as they are in 55.2.0, to keep the change small.

## Oracle failures

- `joins.slt`: the added `EXPLAIN ... JOIN ... ON l.binary_col = r.binary_col` expects a `HashJoinExec`. It now gets a different join plan.
- `information_schema_columns.slt`: not expected to fail from this change, because that file only renames the table.

Actual `check.sh` result: `joins.slt` fails. The join on `binary_col` is planned as `NestedLoopJoinExec` with a filter instead of `HashJoinExec`. `information_schema_columns.slt` passes.
