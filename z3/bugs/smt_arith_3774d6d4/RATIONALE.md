# Rationale
FIX.diff hunk (theory_arith_core.h, mk_underspecified): the fix marks the axiom literal `div0(x)=n` relevant before assigning it. In today's code that logic lives in theory_lra.cpp `found_underspecified` (the default arith solver) as `ctx().add_relevancy_dependency(n, bool_var2expr(lit.var()))`, and theory_arith_core.h already has `mark_as_relevant`. I removed the relevancy line in theory_lra.cpp. The div0 axiom literal is then not relevant, so the model is not made consistent with it, and model validation reports an invalid model (the same bug as #2890).
I did not change theory_arith_core.h; removing its mark_as_relevant line left 2890.smt2 passing, so only the lra change is kept.

Final ./check.sh:
BUILD OK
FAIL z3test:smt2/2890.smt2 (rc=1)
    1a2
    > (error "line 6 column 10: an invalid model was generated")
