# Rationale

Bug: `nanvl(x, y)` returned NULL whenever `y` was NULL, even when `x` was a non-NaN value (pre-fix `arrow::compute::binary` unions the null buffers). The fix treats nulls as ordinary values: return `x` unless `x` is NaN, then `y`.

Changed `datafusion/functions/src/math/nanvl.rs`:

1. `invoke_with_args` scalar path: added an arm for `(Scalar(x), Scalar(y))` with `y` null that returns a typed NULL. This reverses the fix's new scalar fast-path (`(x @ Scalar(_), _) => Ok(x)`), which returns `x` regardless of `y`. The pre-fix scalar path went through arrays and `binary`, so a null `y` nulled the result.
2. `nanvl_impl` null-aware array path: the condition `x.is_valid(i)` became `x.is_valid(i) && y.is_valid(i)`. This reverses the fix's "y is only consulted when x is NaN" semantics, which is the same defect on the array path. The pre-fix `binary` also nulled the output when either input was null.

Oracle cases that fail:
- `scalar.slt`: `select nanvl(2, null)` returns NULL, expected 2.
- `expr.slt`: the `nanvl(1, NULL)` column returns NULL, expected 1.
