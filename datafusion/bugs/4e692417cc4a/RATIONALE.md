# Rationale

Fix #18029 made `LimitPushPastWindows` account for each window function's own `LimitEffect` (e.g. `lead(x, 2)` needs 2 extra rows), not just the frame end bound. Before the fix, only the frame was used to grow the limit.

In 55.2.0 the fix is already in place, so reversing its hunks is not possible. I re-created the pre-fix behaviour in `datafusion/physical-optimizer/src/limit_pushdown_past_window.rs`, in `grow_limit`:

- Removed the `match get_limit_effect(expr) { ... }` block (the `None` / `Unknown` / `Relative` / `Absolute` handling) and `max_rel`.
- Removed the final `ctx.max_lookahead(ctx.lookahead + max_rel)`.

This corresponds to the fix hunk that replaced the frame-only growth loop with `grow_limit` plus `get_limit_effect`. Only the frame end bound now grows the limit, as in the old loop.

## Oracle failure
`window_limits.slt` fails. For `lead(salary, 2) ... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` with `LIMIT 3`, the expected plan is `SortExec: TopK(fetch=5)`. The plan now shows `TopK(fetch=3)`, so the sort drops the rows that `lead` needs and the results would be wrong.
