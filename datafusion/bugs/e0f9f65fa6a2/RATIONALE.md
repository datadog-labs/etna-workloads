# Rationale

Changed `numerical_coercion` in `datafusion/expr-common/src/type_coercion/binary.rs`
(the 55.2.0 home of the old `binary_numeric_coercion` integer arms).

Reverses the first hunk of the fix: combining `UInt64` with `Int8/Int16/Int32/Int64`
no longer yields `Decimal128(20, 0)`; it falls back to `Int64` again (lossy for
values above i64::MAX). The `(UInt64, _) | (_, UInt64) => UInt64` arm is restored
after the Int64 arm, as it was pre-fix. The code is equivalent to the pre-fix
match, just expressed with the current `|` pattern style.

The decimal-conversion hunks (`coerce_numeric_type_to_decimal*`) were left as is.

## Oracle failures
- coalesce.slt: `coalesce(2, arrow_cast(3,'UInt64'))` returns Int64 instead of Decimal128(20, 0).
- insert.slt: inserting large UInt64 literals with signed ones into a bigint unsigned column is mis-coerced.
- joins.slt: `coalesce(sum_col3, 0)` column type mismatch (I vs R).
- union.slt: plan shows `CAST(... AS Int64)` instead of `Decimal128(20, 0)`; column type I vs R.
