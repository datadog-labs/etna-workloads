# Rationale

Bug: `percentile_cont` interpolation on Float16 overflows f16 intermediates and returns NaN (#18945).

Changed only `datafusion/functions-aggregate/src/percentile_cont.rs`:
- `calculate_percentile` interpolation: restored the pre-fix native-type wrapping arithmetic
  (`sub_wrapping`/`mul_wrapping`/`div_wrapping`/`add_wrapping` with `usize_as(fraction * PRECISION)`),
  reversing the fix hunk that moved interpolation to f64 and cast back. For f16, `diff * 500000`
  overflows to inf, and inf/1e6 etc. gives NaN/inf.
- `INTERPOLATION_PRECISION` reverted from `f64` to `usize` and the `ArrowNativeType` import restored
  (needed by `usize_as`), reversing those fix hunks.
- The `AsPrimitive` where-bounds from the fix are left in place; they are harmless and unused.

Oracle: `aggregate.slt` fails: `percentile_cont(0.5) ... arrow_cast(col_f32,'Float16')` returns `NaN` instead of `2.75`.
