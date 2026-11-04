# Rationale

Fix hunk reversed: `EquivalenceProperties::projected_constants` in `properties.rs`, which the fix changed from
`with_across_partitions(true)` to the value of the new `is_expr_constant_accross_partitions(source)`.

In 55.2.0 that logic lives in `EquivalenceGroup::project` (`datafusion/physical-expr/src/equivalence/class.rs`).
It propagates the source's `AcrossPartitions` (via `is_expr_constant`) to each projected target.
I changed it so a constant source always yields `AcrossPartitions::Uniform(None)`. This is the
equivalent of the old unconditional `across_partitions = true`. The source's real
`AcrossPartitions` value, such as `Heterogeneous`, is ignored.

The fix's new `is_expr_constant_accross_partitions` helper has no counterpart to revert,
because `is_expr_constant` already returns the `AcrossPartitions` value.

## Oracle
`order.slt` fails. The `name` column is a constant but differs across the two union
inputs, so it is `Heterogeneous`. After the projection, `CASE ... AS a` is wrongly
treated as uniform across partitions. The sort on `a DESC` is then considered
satisfied and `SortPreservingMergeExec` is replaced by `CoalescePartitionsExec`.
This would return wrongly ordered rows.
