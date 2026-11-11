# Rationale
Single hunk, src/src/solver/tactic2solver.cpp, tracing to the tactic2solver.cpp hunk of FIX.diff.
The fix disabled `(*m_mc)(md);` (applying the solver's previous model converter to the model returned by
the tactic) in check_sat_core2. Today's code has no such line, so I re-added
`if (m_mc && md) (*m_mc)(md);` before the trace/`m_mc = g->mc()`. The stale converter from an earlier check
is applied to the new model, which then becomes invalid (3115, 3116: "an invalid model was generated").

Final ./check.sh:
BUILD OK
PASS z3test:smt2/3111.smt2
FAIL z3test:smt2/3115.smt2 (rc=1)
FAIL z3test:smt2/3116.smt2 (rc=1)
