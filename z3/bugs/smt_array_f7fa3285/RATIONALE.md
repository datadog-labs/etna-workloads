Changed file: src/src/smt/theory_array_full.cpp (has_non_beta_as_array and is_supported_array_eq).

Hunk 1 (FIX.diff hunk 1): in the lambda-parent loop, removed `!is_array_ext(p->get_expr())`.
array-ext parents of lambdas are again treated as unsupported, so final-check gives up (FC_GIVEUP -> unknown).

Hunk 2 (FIX.diff hunk 2): in is_supported_array_eq, removed `|| ctx.is_diseq(arg0, arg1)`.
Only same-root equalities count as supported (the pre-fix is_congruent_eq semantics), so disequal array
equalities again trigger the give-up.

The rename and header change are cosmetic and were not reverted.

Result: ./check.sh builds OK; smt_context FAILS (the lira test no longer returns sat).
Final check.sh output:
BUILD OK
FAIL smt_context (rc=114)
    unknown
    ASSERTION VIOLATION ... Failed to verify: cmd.cs_state() == cmd_context::css_sat
