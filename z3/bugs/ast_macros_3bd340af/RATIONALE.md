Single file changed: src/src/ast/macros/quasi_macros.cpp, in quasi_macro_to_macro.

Traces to the FIX.diff hunk that adds `if (!is_var(arg) && !is_ground(arg)) return false;` (and makes
quasi_macro_to_macro return bool so the caller skips the macro). In today's code that guard is
paired with a later `num_seen < q->get_num_decls()` bail-out that also returns false. I removed both,
so a quasi-macro whose head has non-variable, non-ground arguments is no longer rejected.
That is the #3705 bug: a bogus macro is built, and the sort-mismatch assertion
(v->get_sort() == r->get_sort()) fires on smt2/3705.smt2.

Final ./check.sh: BUILD OK, z3test:smt2/3705.smt2 FAIL (assertion violation in rewriter_def.h:52).
