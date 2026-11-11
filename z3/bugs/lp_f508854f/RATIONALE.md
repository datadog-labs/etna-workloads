# Rationale

## Changed hunk

`src/src/math/lp/int_solver.cpp`, in `int_solver::imp::check()`: removed the line

    if (r == lia_move::undef && should_find_lcube()) r = find_lcube();

**Traces to:** FIX.diff, `src/math/lp/int_solver.cpp` hunk `@@ -246,6 +267,7 @@`. That hunk added
this line to the integer-feasibility dispatch in `check()`.

**Why this brings back the behavior the fix removed:** before the fix, `int_solver::check()` never
ran the largest cube test of Bromberger and Weidenbach. It ran only the unit cube test
(`int_cube(lia)()`) and then went on to branching and cuts. On problems where the polyhedron's
largest inscribed cube is smaller than a unit cube but its rounded center (or a single flip of it)
is integer-feasible, the old code could not find the solution that way. It returned `branch`
instead of `sat`. Removing the dispatch line restores that pre-fix control flow. The rest of
today's lcube code (`find_largest_cube`, `find_lcube`, the parameters, the statistics) stays in
the tree but is never reached from `check()`, just as before the fix. The tree still builds.

## Hunks considered and not used
- `lar_solver.cpp` `@@ -879,6 +879,11 @@` (the `!fix_int_cols` early return in `maximize_term`):
  I tried removing it first, so that maximize_term always runs `adjust_integer_columns` as it
  did before the fix. Both oracle units still passed, so I reverted it to keep the change minimal.
- `util/mpz.cpp` `hash` (`::abs(INT_MIN)` UB): on this platform `::abs(INT_MIN)` gives the same
  bit pattern as the unsigned computation. No oracle test can observe it, so I did not use it.

## Final ./check.sh output
```
BUILD OK
FAIL lcube (rc=114)
    unit cube returned undef
    lcube returned sat
    lcube: rounding repair
    lcube returned sat, flip successes: 1
    lcube: infinite lattice width
    lcube returned sat
    lcube: edge length at least 1
    lcube returned sat
    lcube: dispatch through int_solver::check
    check returned branch, lcube calls: 0
    ASSERTION VIOLATION
    File: <z3-src>/src/test/lcube.cpp
    Line: 241
    Failed to verify: m == lia_move::sat
    
PASS lp_matrix
```
