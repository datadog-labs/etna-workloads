# Rationale

File: src/backend/optimizer/util/clauses.c, function max_parallel_hazard_walker, SubPlan branch.
Traces to the fix.patch clauses.c hunk that replaced `return !((SubPlan *) node)->parallel_safe;`
with a walk of the SubPlan's testexpr and args, using safe_param_ids.

I restored the old one-line `return !subplan->parallel_safe`. The walker no longer examines
the SubPlan's testexpr or args, so parallel-restricted expressions in them (for example
restricted Params) are missed and the SubPlan is wrongly treated as parallel-safe.
The safe_param_ids infrastructure is left in place; it is now unused for SubPlans.
The Param branch and the primnodes.h comment hunk are left alone (the comment is not behavioral).

Failing oracle case: src/test/regress||select_parallel
