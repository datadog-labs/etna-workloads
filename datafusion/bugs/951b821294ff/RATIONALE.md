# Rationale

## Hunks changed
1. `datafusion/functions/src/math/round.rs`, `RoundFunc::new`: removed the `integer` coercion and the two
   `TypeSignature::Coercible([integer, decimal_places])` / `([integer])` entries (reverses the fix's signature hunk).
   Integer inputs again fall through to the `float64` implicit coercion, so `round(Int64)` goes via Float64 and
   loses precision above 2^53 and returns a Float64 type. The other fix additions (integer return-type arm,
   `round_integer_*` helpers) are now unreachable but left in place, as the signature is what routes inputs to them.
2. `datafusion/spark/src/function/math/round.rs`, `spark_round` array `DataType::UInt64` arm: restored the old
   `try_unary` with `i64::try_from`, which errors for values above i64::MAX even with non-negative scale
   (reverses the fix's array hunk). The scalar UInt64 arm was not changed.

## Oracle failures
- scalar.slt: the new round(Int64/UInt64) cases fail with wrong type/value (Float64 `R` instead of Int64/UInt64).
- select.slt: the plan now shows `round(CAST(b AS Float64))` instead of `round(b)`.
- spark/math/round.slt: no oracle case fails (the added queries use scalars, which take the scalar path).
