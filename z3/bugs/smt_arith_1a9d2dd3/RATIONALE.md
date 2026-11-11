# Rationale
Only the smt_context.cpp hunk of FIX.diff could be re-expressed. The release already contained the pivot-cost charging, lp_settings and theory_lra hunks. The lar_solver hunk was already in its buggy form.

Changed hunk: src/smt/smt_context.cpp, `context::propagate()`. `propagate_theories()` is moved back inside the `scoped_suspend_rlimit` block, which is active at base level. This undoes the FIX.diff hunk that moved it outside. Theory propagation, including the LP solver, is again run with cancellation suspended at base level. This is the bug in #11272.

Result of ./check.sh:
BUILD OK
PASS opt_bounds
FAIL smt_context (rc=114): assertion `pivots == 0` at test/smt_context.cpp:135 (check_arithmetic_propagation_cancellation)
