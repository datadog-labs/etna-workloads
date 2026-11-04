# Rationale

Fix hunk reversed: in `datafusion/expr-common/src/type_coercion/binary.rs`, the fix moved the
arithmetic arms of `mathematics_numerical_coercion` into the shared `numerical_coercion`
(which adds `UInt64` + signed -> `Decimal128(20, 0)`, and `UInt32`/`UInt16` + smaller signed ->
`Int64`/`Int32`).

Change: the `_` arm of `mathematics_numerical_coercion` no longer delegates to
`numerical_coercion`; it again has the pre-fix inline arms (signed types win over unsigned:
`Int64`, `Int32`, `Int16`, `Int8` before `UInt64`...`UInt8`). This is the exact pre-fix match
(plus the `Float16` arm that exists in 55.2.0).
`binary_numeric_coercion` (comparison/bitwise path) still uses `numerical_coercion`; the
pre-fix version of that path was equivalent in 55.2.0, so it is left alone.

Effect: `UInt32 + Int32` -> Int32, `UInt64 + Int64` -> Int64 (silent overflow/truncation),
instead of Int64 / Decimal128(20, 0).

Oracle cases expected to fail: operator.slt (arrow_typeof of arithmetic over the numeric types
shows Int64 instead of Decimal128(21,0) etc.), math.slt (column types for UInt64*0), and
window.slt (plan with CAST(.. AS Int32) instead of Decimal128(20, 0)).
