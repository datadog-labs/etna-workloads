# Rationale

Hunk reversed: `numerical_coercion` in `datafusion/expr-common/src/type_coercion/binary.rs`
(fix hunk `@@ -1044`): removed the `(_, Float16) | (Float16, _) => Some(Float16)` arm.
The decimal-coercion Float16 arms (`coerce_numeric_type_to_decimal*`) already exist in 55.2.0 and were left alone;
the numerical_coercion arm is the one that makes Float16 combine with other numerics.

Without it, Float16 vs integer types falls through to the integer-coercion logic, so the Float16 column is
cast to Int8/Int16/... and NaN fails to cast.

Oracle failures (float16.slt): the arithmetic query (line 37) and the equality query (line 64) both fail with
`Cast error: Can't cast value NaN to type Int8`.
