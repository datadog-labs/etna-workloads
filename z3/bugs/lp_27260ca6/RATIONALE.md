# Rationale

Traces to the lar_solver.cpp and lar_solver.h hunks of FIX.diff. Those hunks replace the
delta-flattened check in `all_constraints_hold()` and `constraint_holds()` with an `impq`
check. The release already contains the fixed `impq` version, and a verbatim reversal does not
make any oracle test fail. In the reintroduced code, `all_constraints_hold()` computes
`find_delta_for_strict_bounds` and flattens the model to rationals. `constraint_holds(constr, var_map)`
compares rationals and ignores the `bound_eps` component of the bound. This is the
"flatten infinitesimals through a chosen delta" bug the fix describes. Unlike the exact reversal,
it does not add `bound_eps*delta` to the rhs. Strict optimization bounds are then misjudged,
and the debug assertion at lar_solver.cpp:1464 fires.

The header hunk changes the `constraint_holds` signature to match.

Final ./check.sh: BUILD OK; PASS api, box_independent, box_mod_opt, max_rev, scaled_min; FAIL opt_dup_min (assertion violation, lar_solver.cpp:1464).
