# Rationale

Hunk reversed: `datafusion/expr-common/src/interval_arithmetic.rs`, `Interval::cardinality()`.
The fix replaced `.map(|result| result + 1)` with `.and_then(|result| result.checked_add(1))`.
55.2.0 still had the fixed line, so I restored the original `.map(|result| result + 1)`.
For a full-range i64/u64 interval, `distance_u64` returns `u64::MAX`, so the `+ 1` overflows.

Oracle: `select.slt` fails. `x BETWEEN i64::MIN AND i64::MAX` panics with "attempt to add with overflow" at interval_arithmetic.rs:953.
