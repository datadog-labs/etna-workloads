# Rationale

## src/backend/commands/tablecmds.c, ATExecAddColumn
Traces to the fix.patch hunk in AddRelationNewConstraints (heap.c), which changed
`contain_volatile_functions(expr)` to `contain_volatile_functions_after_planning(expr)`
for the "DEFAULT is volatile, cannot use a missing value" check. In current code that
check lives in ATExecAddColumn and runs on `defval` after expression_planner().
I keep the raw (unplanned) expression in `rawdefval` and run the volatility check on it,
so default arguments (e.g. `foolme(timestamptz DEFAULT clock_timestamp())`) and inlining
are not seen. A volatile default argument is then missed and a missing value is stored
instead of rewriting the table.

Expected failing oracle case: src/test/regress||fast_default
