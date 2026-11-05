# Rationale
- File/function: src/backend/optimizer/util/clauses.c, eval_const_expressions_mutator (T_FieldSelect case).
- Traces to the fix_impl.patch hunk that added `varlevelsup == 0` to the whole-row Var check. I removed that condition (the comment update is not reverted).
- Effect: FieldSelect on an uplevel (lateral) whole-row Var is again replaced by a simple Var. The reltargetlist already contains the whole-row Var, so setrefs.c fails.

Failing oracle case: src/test/regress||rangefuncs
