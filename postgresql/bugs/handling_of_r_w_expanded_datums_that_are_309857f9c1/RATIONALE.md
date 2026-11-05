# Rationale

File: src/backend/executor/functions.c, function postquel_sub_params()

Hunk 1 (traces to the fix.patch hunk that sets `prm->value = MakeExpandedObjectReadOnly(...)`):
the argument is again stored as `prm->value = fcinfo->args[i].value;`, so an R/W expanded
datum passed to a SQL function stays R/W. If the parameter is referenced more than once
(e.g. `array_append($1,$2) || array_append($1,$2)`), the first reference modifies the array
in place and the later reference sees the modified value.

Hunk 2 (same place; the pre-fix code had `prm->pflags = 0;`): today's code sets
`PARAM_FLAG_CONST`, which lets the planner substitute the param as a Const via `datumCopy`.
That copy flattens the expanded datum and hides the bug, so reverting hunk 1 alone doesn't
fail any test. I restored `prm->pflags = 0;` so the R/W pointer reaches execution as it did
before the fix. This is an adaptation to current code, not a separate bug.

Failing oracle cases: src/test/regress||create_function_sql
