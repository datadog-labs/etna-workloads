# Rationale

Changed hunk: `optsmt::lex()` in src/src/opt/optsmt.cpp.

Traces to the FIX.diff hunk in `optsmt::lex` ("Clear later objectives' lower bounds in lex() only after the current geometric search succeeds"; the removed code sat at the end of the old geometric_lex after success). I undid it: later objectives' lower bounds are now cleared unconditionally before the search, so an UNKNOWN/failed first objective erases the later objective's model-derived lower bound. This is the bug the new test checks.

Final ./check.sh:
BUILD OK
FAIL opt_bounds (rc=114)  -- ASSERTION at src/test/opt_bounds.cpp:1064
  Failed to verify: optimizer.get_lower(second).rational_bound() == opt::inf_eps(initial_y)
