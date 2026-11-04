# Rationale

In 55.2.0 the fix is already present in the tree. The `timeunit_coercion` hunk and the overflow-check hunks all exist in some form.

## Changed hunk
`datafusion/expr-common/src/type_coercion/binary.rs`, `timeunit_coercion`. This reverses the fix hunk of the same name. It restores the pre-fix match table, where mixed units coerce to the coarser unit. The `(l, r)` arm with `assert_eq!` is restored too. The match is equivalent to the old code, so Second/Millisecond comparisons, subtraction, UNION and COALESCE lose sub-unit precision again.

The overflow-check hunks in `scalar/mod.rs` and `columnar_value.rs` are left alone. They are harmless without the finer-unit coercion, and the bug is the coercion choice.

## Oracle failures
`datetime/timestamps.slt` fails.
- The Second vs Millisecond comparison and the UNION and COALESCE cases now report the coarser type (`Timestamp(s)`) instead of `Timestamp(ms)`.
- Subtracting a Microsecond timestamp from a Nanosecond one prints `0.000000 secs` instead of `0.000000000 secs`.
