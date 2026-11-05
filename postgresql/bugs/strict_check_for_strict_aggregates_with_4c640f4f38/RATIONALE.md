# Rationale
- File/function: src/backend/executor/execExpr.c, ExecBuildAggTrans (strict input check step).
- Traces to the single fix.patch hunk in execExpr.c: `nargs = numInputs` -> `pertrans->numTransInputs`. Reversed here: `nargs = pertrans->numInputs`.
- Why it brings back the bug: the strict check then covers all computed inputs, including ORDER BY/DISTINCT columns, not just the transition function's arguments. A NULL in a sort column wrongly skips the transition call for a strict aggregate.

Failing oracle case: src/test/regress||aggregates
