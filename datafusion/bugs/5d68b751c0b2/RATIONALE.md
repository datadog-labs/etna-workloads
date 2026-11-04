# Rationale

Fix hunk reversed: `compute_truncate32` / `compute_truncate64` in `datafusion/functions/src/math/trunc.rs` changed `.round()` to `.trunc()`.

In 55.2.0 both helpers (and the array fast path `truncate_float_array`) delegate to the shared `truncate_with_factor`, which holds the computation `(x * factor).trunc() / factor`. I changed that single line back to `.round()`. That restores the pre-fix behaviour on every float path with a precision argument (scalar, array, and the helpers).

Oracle: `scalar.slt` fails on the `trunc(sqrt(abs(a)), 3)` query. The row for 0.83666... gives `0.837` instead of `0.836`, and `a3_f64` shows the same difference. The `a1` column and the other rows are unaffected.
