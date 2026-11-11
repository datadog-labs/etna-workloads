Single hunk in src/src/solver/tactic2solver.cpp (check_sat_core2), tracing to the sole FIX.diff hunk.
Restored the pre-fix code: apply the accumulated m_mc to the model (`(*m_mc)(md)`) and accumulate
with `m_mc = concat(g->mc(), m_mc.get())` instead of `m_mc = g->mc()`. Converters from earlier
check-sat calls are then applied again to models, giving invalid models (#3244).

Final ./check.sh: BUILD OK; FAIL z3test:smt2/3244.smt2 (rc=1) -
"an invalid model was generated" errors at lines 17 and 29.
