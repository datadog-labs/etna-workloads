# Rationale

Fix: "Support aggregate expressions in QUALIFY" (#17313).

## Change (`datafusion/sql/src/select.rs`, `select_to_plan`)

The fix added `.chain(qualify_expr_opt.iter())` to the haystack searched by
`find_aggregate_exprs`, so aggregates that appear only in QUALIFY (e.g.
`QUALIFY ... AND SUM(salary) > 1000`) are included in the Aggregate node. In 55.2.0
this is the `select_having_qualify_aggrs` computation (the haystack was later merged
with ORDER BY / DISTINCT ON handling). I removed the QUALIFY chain, restoring the
pre-fix haystack of SELECT + HAVING only.

The rest of the fix (passing qualify through `aggregate()`, rebasing it, and
the `Qualify` check purpose) is still present in 55.2.0 and is left as is. Without
the aggregate collected, rebasing cannot replace `SUM(salary)` with a column, so the
check reports the input column as ungrouped.

## Oracle failure

`qualify.slt` fails at the case "QUALIFY with aggregate function" (line 218):
`Error during planning: Column in QUALIFY must be in GROUP BY or an aggregate function: ... column "users.salary" must appear in the GROUP BY clause ...`
instead of returning `Marketing`.
