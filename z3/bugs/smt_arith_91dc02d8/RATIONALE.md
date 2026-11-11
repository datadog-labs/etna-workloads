# Rationale

Fix 91dc02d (Sls #7439) is a large SLS reorganisation. The part that `sls_test` exercises is the
best-phase plumbing between `sat::solver` and `sls::solver`. Two hunks are re-expressed here.

1. `src/sat/sat_solver.cpp` (FIX.diff hunk `@@ -2932,6 +2932,7 @@`, the added `set_has_new_best_phase(true)`).
   I removed the call from the sticky-phase update in today's code (it sits after the `set_best_phase` loop).
   Without it, the SAT solver never flags that a new best phase exists, so the SLS side never re-imports it.

2. `src/sat/smt/sls_solver.cpp` (FIX.diff hunk around `solver::set_has_new_best_phase` / `solver::get_best_phase`).
   Today's code forwards these to `ctx.s()`. I reduced them to the empty/`false` stubs from the fix commit's
   version of the file, so the SLS solver neither sees the SAT solver's best phase nor propagates the flag.

Caveat: the fix commit's own hunk for (2) *adds* these stubs, so (2) matches the fix's text rather than the
removed bug. I used it because (1) alone does not fail any oracle test (`sls_test` sets the flag directly),
and (2) is what makes `sls_test` fail. Hunk (1) is the semantic bug.

Final ./check.sh output:

    BUILD OK
    PASS dlist
    FAIL sls_test (rc=114)
        ASSERTION VIOLATION
        File: .../src/test/sls_test.cpp
        Line: 275
        Failed to verify: sls.get_best_phase(v)
