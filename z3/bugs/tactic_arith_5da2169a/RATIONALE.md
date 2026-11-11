Changed hunk: src/src/tactic/arith/eq2bv_tactic.cpp, in eq2bv_tactic::operator(): removed `m_bounds.inconsistent() ||` from the early-return condition.
Traces to the FIX.diff hunk in eq2bv_tactic.cpp that added `if (m_bounds.inconsistent()) { inc_depth; push; return; }`. Without it, the tactic rewrites goals with contradictory bounds, producing an invalid model (sat instead of unsat) on 3524.smt2.
(bound_manager::inconsistent itself is left in place, since it exists in today's code.)

Final check.sh output:
BUILD OK
FAIL z3test:smt2/3524.smt2 (rc=1)
    < unsat
    > sat
    > (error "line 39 column 10: an invalid model was generated")
