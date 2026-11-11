# Rationale
Changed hunk: src/src/tactic/arith/eq2bv_tactic.cpp, line ~205: removed `&& !m_has_eq.is_marked(var)` from the is_bound check.
Traces to FIX.diff hunk `@@ -197,7 +199,7 @@` (the guard). Without it, bound constraints on variables that also appear in equalities are replaced by true and handled by the model converter alone, which gives an invalid model (issue #3385). The other hunks (m_has_eq declaration/reset, mark_has_eq, trail push) are already present in this release in a different form, so only the guard was removed.
Final check.sh: BUILD OK; FAIL z3test:smt2/3385.smt2 (rc=1) -- "an invalid model was generated"
