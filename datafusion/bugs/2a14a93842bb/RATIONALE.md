# Rationale

Fix hunk reversed: `datafusion/functions-aggregate/src/median.rs`, `Median::new()`.
The fix replaced `Signature::numeric(1, Volatility::Immutable)` with a `one_of` signature
that coerces integer inputs to Float64. In 55.2.0 that hunk applies as-is, so reversing it
restores `Signature::numeric(1, ...)`. The `Coercion`, `TypeSignature`, `TypeSignatureClass`,
`NativeType` and `logical_float64` imports the fix added were removed because they are now unused.

With the numeric signature, integer inputs are not coerced. `return_type` returns the input
type, so `median` over integers returns an integer and the average of the two middle values
is truncated (for example `median(-128, 127)` gives 0 instead of -0.5).

Oracle cases that fail: the `aggregate.slt`, `aggregate_skip_partial.slt` and
`clickbench_extended.slt` queries that now declare `R` columns for integer medians fail
on the column type and on the truncated values. The `median(DISTINCT c)` explain plan
also loses its `CAST(... AS Float64)`.
