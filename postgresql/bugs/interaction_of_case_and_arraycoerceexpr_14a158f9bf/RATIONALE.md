# Rationale
Both hunks are in src/backend/optimizer/util/clauses.c and trace to the clauses.c hunks of fix.patch.

1. `contain_context_dependent_node_walker`: removed the `ArrayCoerceExpr` branch. This undoes the part of the fix that lets a CaseTestExpr appear only inside an ArrayCoerceExpr's elemexpr. SQL-function inlining can now put a bare CaseTestExpr under an ArrayCoerceExpr or CASE without noticing.
2. `eval_const_expressions_mutator`, `case T_ArrayCoerceExpr`: went back to `ece_generic_processing()`. `context->case_val` is no longer cleared while the elemexpr is simplified, so the elemexpr's CaseTestExpr can absorb an outer CASE value.

I did not revert the comment and macro-rename hunks (execExpr.c, parse_coerce.c, parse_target.c, primnodes.h), since they don't change behavior.

Oracle case that should fail: src/test/regress||case (the regression suite, in the test covering CASE with ArrayCoerceExpr). I had not seen the oracle output when I wrote this.
