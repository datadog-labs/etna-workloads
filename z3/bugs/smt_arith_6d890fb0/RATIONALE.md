# Rationale

Changed hunk: `max_with_nl()` in src/src/smt/theory_lra.cpp. It traces to the theory_lra.cpp hunk of FIX.diff
("return LP optimum as bound regardless of NLA result"). The upstream fix made `max_with_nl` return the saved LP
optimum together with a blocker built via `mk_gt(v, lp_ival)`, whatever `check_nla` returned.
I undid that. On FC_DONE and FC_CONTINUE it now only sets st=FEASIBLE and falls through to `max_result`
(restoring x on CONTINUE). The saved-LP-optimum value, the blocker and the early return are gone. The old
behaviour is back: the NLA result discards the LP optimum, and the optimizer cannot validate it through
`check_bound` with the accumulated NLA lemmas.

The release already contains the other hunks of the fix (relaxed restore_x, the three helpers, the mk_gt overload), so I left them alone.

Final ./check.sh output:
BUILD OK
PASS api
PASS box_independent
PASS box_mod_opt
PASS lp_matrix
FAIL max_rev (rc=110) ASSERTION VIOLATION lar_solver.cpp:1727
  (status != OPTIMAL && status != FEASIBLE) || rslv.calc_current_x_is_feasible_include_non_basis()
PASS opt_dup_min
PASS scaled_min
