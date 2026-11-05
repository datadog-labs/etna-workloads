# Rationale

Hunk: src/pl/plpgsql/src/pl_exec.c, exec_eval_simple_expr (replan path).
Traces to the fix.patch hunk that added `exec_is_simple_query(expr) &&` to the
condition before CachedPlanAllowsSimpleValidityCheck after replanning. Removing
it means a replanned expression is not rechecked for simplicity (e.g. a non-SRF
function replaced by an SRF), so it is still run via the simple-expression path.

Failing oracle case: src/pl/plpgsql/src||plpgsql_simple
