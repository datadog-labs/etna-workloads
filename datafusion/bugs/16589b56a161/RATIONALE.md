# Rationale

Fix hunk reversed: `NthValueEvaluator::evaluate` (the bounded-execution memoization decision), `Ordering::Equal => (false, false)` -> `(true, false)`.
The code moved from datafusion/physical-expr/src/window/nth_value.rs to datafusion/functions-window/src/nth_value.rs (line 439), but the match is identical. The change is one line, so it is the same defect.

With `n == 0` (a NULL offset is treated as 0), the pre-fix code marks the window prunable. It then runs `state.window_frame_range.end - 1` style pruning and `try_from_array(out, size - 1)`, which breaks when the output is empty. The fix returns not prunable.

Oracle: window.slt, case `SELECT NTH_VALUE(tt0.v1, NULL) OVER (PARTITION BY tt0.v2 ORDER BY tt0.v1) FROM t AS tt0;` fails with panic "attempt to subtract with overflow" (nth_value.rs:445) instead of returning NULLs.
