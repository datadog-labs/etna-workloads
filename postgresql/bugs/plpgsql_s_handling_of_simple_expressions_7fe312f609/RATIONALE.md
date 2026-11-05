# Rationale

File: src/pl/plpgsql/src/pl_exec.c, function exec_save_simple_expr.
Traces to the fix_impl.patch hunk changing `IsA(plan, Gather)` to `IsA(plan, Gather) || IsA(plan, Material)`. The comment hunk is not reverted.
I reverted the condition to `IsA(plan, Gather)` only. For scrollable cursors the planner puts a Material node atop the Result. The simple-expression check then no longer looks through it, so the expression is not recognized as simple or hits the wrong path.

Failing oracle case: src/pl/plpgsql/src||plpgsql_simple
