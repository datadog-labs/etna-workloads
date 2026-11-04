# Rationale

Fix (#19303) changed `PowerFunc::coerce_types` so integer/null bases coerce to Float64, and removed the
`(Int64, _)` integer-power branch of `invoke_with_args`. In 55.2.0 `power` uses a coercible
Float64 signature, so neither hunk applies directly. In `datafusion/functions/src/math/power.rs` I restored the pre-fix design:

- `Signature::coercible(Float64 x2)` -> `Signature::user_defined`, with a `coerce_types` that keeps
  integer/null args as Int64 and sends floats/decimals to Float64 (the pre-fix `coerced_type_base`/`_exp`
  behaviour that the fix's `coerce_types` hunk rewrote).
- `return_type` returns Int64 for an Int64 base (else Float64), matching the integer result.
- `invoke_with_args`: re-added the `(Int64, _)` branch (`pow_checked`, exponent cast to Int64, "out of
  bounds" error for negative exponent) that the fix removed; Float64 arm matches `(Float64, _)`.

Oracle failures: scalar.slt (power(2,null), power(null,null), `2 ^ 3`, the power table query) fail with
column-type mismatches (I instead of R), and `pow(10, -2.0)` / `pow(2, -0.5)` in decimal.slt/math.slt hit
"Exponent -2 in integer computation is out of bounds" (the original regression).
