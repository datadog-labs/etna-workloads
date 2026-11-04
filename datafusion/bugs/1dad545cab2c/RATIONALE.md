# Rationale

Change: `tree/datafusion/expr-common/src/interval_arithmetic.rs`

Fix hunk reversed: the `get_extreme_value!` macro hunk that added the `Decimal128` and `Decimal256` arms (using the `MIN/MAX_DECIMAL{128,256}_FOR_EACH_PRECISION` tables).

- I removed those two arms, so decimals fall through to `_ => unreachable!()`. This is the pre-fix behaviour.
- I also reverted the macro signature, the two call sites in `sub_bounds` and the `arrow::datatypes` imports to their pre-fix form. This is only so the code compiles without unused-item warnings.
- The Cargo.toml/Cargo.lock hunks (the `paste` dependency) are build files and untouched. 55.2.0 no longer uses `paste` there.

Failing oracle case: `select.slt`, the query `SELECT ('0.5432...'::DECIMAL(35,35) + 10000)::VARCHAR`.
- Expected: an "Arithmetic overflow" error.
- Actual: a panic, "internal error: entered unreachable code", at `interval_arithmetic.rs:1208`, in the extreme-value computation for the decimal type.
- This matches the original issue #14124, where the overflow path panicked for decimals.
