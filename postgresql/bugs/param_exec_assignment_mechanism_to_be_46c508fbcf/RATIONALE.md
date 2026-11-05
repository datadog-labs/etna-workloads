# Rationale

Changed file: src/src/backend/optimizer/path/allpaths.c, function set_subquery_pathlist().

Traces to the fix.patch allpaths.c hunks (the "Assert(root->plan_params == NIL)" and
"Isolate the params needed by this specific subplan: rel->subplan_params = root->plan_params;
root->plan_params = NIL;" hunks).
The fix keeps the PlannerParamItems of each subquery separate. I removed the isolation: root->plan_params is no longer
reset after planning a subquery-in-FROM (and the "not in use" Assert is dropped). Params from
different subqueries at the same level now accumulate in one list, so identical Vars (same
varno/varattno) in different subqueries/CTEs share one PARAM_EXEC slot. That is the original bug:
a lazily-evaluated CTE can run while another subquery's params in the same slot are live.

Failing oracle case: src/test/regress||with
